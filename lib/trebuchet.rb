require 'aws-sdk'
require 'grit'
require 'optparse'
require 'securerandom'
require 'zip/zip'
require_relative 'trebuchet/version'
require_relative 'utils.rb'

module Trebuchet

  class Aws

    def deploy(git_url, name, options = {})

      configure_aws

      s3 = AWS::S3.new

      eb = AWS::ElasticBeanstalk.new
      eb_client = eb.client.with_options(region: 'ap-southeast-2')

      cf = AWS::CloudFormation.new
      cf_client = cf.client.with_options(region: 'ap-southeast-2')

      version_label = SecureRandom.uuid
      s3_key_name = "#{name}-#{version_label}.zip"

      artifact_zip = artifact_zip_from_git(git_url, options[:sha])

      storage_location = eb_client.create_storage_location[:s3_bucket]
      bucket = s3.buckets[storage_location]
      bucket.objects[s3_key_name].write(artifact_zip)

      version = eb_client.create_application_version(application_name: name,
                                                     version_label: version_label,
                                                     source_bundle: { s3_bucket: storage_location, s3_key: s3_key_name },
                                                     auto_create_application: true)

      env_name = safe_environment_name(name, version_label)
      eb_client.create_environment(application_name: name,
                                   version_label: version_label,
                                   environment_name: env_name,
                                   solution_stack_name: '64bit Amazon Linux running Ruby 1.9.3')

    end

    private

    def artifact_zip_from_git(git_url, git_sha)
      Dir.mktmpdir do |tmp_dir|
        git = Grit::Git.new('')
        git.clone({ quiet: true, progress: false }, git_url, tmp_dir)

        Dir.chdir(tmp_dir) do
          # can't use grit here because https://github.com/mojombo/grit/issues/166
          safe_system("git checkout #{git_sha} --quiet") if git_sha

          safe_system('bundle install')
          safe_system('bundle exec rake build')
        end

        zip_from_directory(tmp_dir)
      end
    end

    def configure_aws
      AWS.config(# endpoints for Sydney
                 auto_scaling_endpoint: 'autoscaling.ap-southeast-2.amazonaws.com',
                 cloud_formation_endpoint: 'cloudformation.ap-southeast-2.amazonaws.com',
                 cloud_watch_endpoint: 'monitoring.ap-southeast-2.amazonaws.com',
                 dynamo_db_endpoint: 'dynamodb.ap-southeast-2.amazonaws.com',
                 ec2_endpoint: 'ec2.ap-southeast-2.amazonaws.com',
                 elasticache_endpoint: 'elasticache.ap-southeast-2.amazonaws.com',
                 elastic_beanstalk_endpoint: 'elasticbeanstalk.ap-southeast-2.amazonaws.com',
                 elb_endpoint: 'elasticloadbalancing.ap-southeast-2.amazonaws.com',
                 rds_endpoint: 'rds.ap-southeast-2.amazonaws.com',
                 s3_endpoint: 's3-ap-southeast-2.amazonaws.com',
                 simple_db_endpoint: 'sdb.ap-southeast-2.amazonaws.com',
                 simple_workflow_endpoint: 'swf.ap-southeast-2.amazonaws.com',
                 sns_endpoint: 'sns.ap-southeast-2.amazonaws.com',
                 sqs_endpoint: 'sqs.ap-southeast-2.amazonaws.com',
                 storage_gateway_endpoint: 'storagegateway.ap-southeast-2.amazonaws.com',

                 # credentials
                 access_key_id: ENV['EB_ACCESS_KEY_ID'],
                 secret_access_key: ENV['EB_SECRET_ACCESS_KEY'])
    end

    def safe_system(command)
      system("#{command} > /dev/null") or raise "Could not run '#{command}' in '#{Dir.pwd}'"
    end

    def zip_from_directory(directory)
      string_io = Zip::ZipOutputStream::write_buffer do |zipfile|
        filenames_from_directory(directory).each do |pathname|
          zipfile.put_next_entry(pathname.sub(directory + '/', ''))
          zipfile.write(File.read(pathname))
        end
      end
      string_io.rewind
      string_io.sysread
    end

  end
end

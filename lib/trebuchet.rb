#!/usr/bin/env ruby

require 'aws-sdk'
require 'grit'
require 'optparse'
require 'securerandom'
require 'zip/zip'
require_relative 'aws.rb'
require_relative 'build.rb'
require_relative 'utils.rb'
require_relative 'trebuchet/version'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: trebuchet [options]'

  opts.on('-g', '--git URL', 'Clones and installs from the Git repo at URL') { |git| options[:git] = git }
  opts.on('-s', '--sha SHA', 'Clones and installs from the specified Git SHA') { |sha| options[:sha] = sha }
  opts.on('-n', '--name NAME', 'Installs an application called NAME') { |name| options[:name] = name }
  opts.on('-c', '--create-env', 'Creates a new arbitrarily-named environment') { options[:create_env] = true }

  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    exit
  end
end.parse!

if !options[:create_env]
  raise ArgumentError.new('You must install an environment with --create-env')
end

if !options[:name]
  raise ArgumentError.new('You must specify an application name with --name when creating a new environment')
end

if !options[:git]
  raise ArgumentError.new('You can install from --git only')
end

configure_aws

s3 = AWS::S3.new

eb = AWS::ElasticBeanstalk.new
eb_client = eb.client.with_options(region: 'ap-southeast-2')

cf = AWS::CloudFormation.new
cf_client = cf.client.with_options(region: 'ap-southeast-2')

version_label = SecureRandom.uuid
s3_key_name = "#{options[:name]}-#{version_label}.zip"

artifact_zip = artifact_zip_from_git(options[:git], options[:sha])

storage_location = eb_client.create_storage_location[:s3_bucket]
bucket = s3.buckets[storage_location]
bucket.objects[s3_key_name].write(artifact_zip)

version = eb_client.create_application_version(application_name: options[:name],
                                               version_label: version_label,
                                               source_bundle: { s3_bucket: storage_location, s3_key: s3_key_name },
                                               auto_create_application: true)

env_name = safe_environment_name(options[:name], version_label)
eb_client.create_environment(application_name: options[:name],
                             version_label: version_label,
                             environment_name: env_name,
                             solution_stack_name: '64bit Amazon Linux running Ruby 1.9.3')

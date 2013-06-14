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




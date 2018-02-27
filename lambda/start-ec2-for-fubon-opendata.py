import boto3
import os
# 這隻 python code 放在 lambda 裡面喚起 EC2 instance 
# 1. 請在 Lambda 的 Environment variables 中設定
#  Key=EC2_ID, value=要喚起的 EC2 ID
# 2. Basic Setting
#  Timeout=30 sec
# 3. CloudWatch Events 
#  設定  cron(0 19 * * ? *), 這是指 UTC 時間 19:00 會使用這隻 python codes
# Enter the region your instances are in. Include only the region without specifying Availability Zone; e.g., 'us-east-1'
region = 'ap-northeast-1'
# Enter your instances here: ex. ['X-XXXXXXXX', 'X-XXXXXXXX']
instances_str=os.environ['EC2_ID']

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name=region)
    instances=instances_str.split(',')
    ec2.start_instances(InstanceIds=instances)
    print('start your instances: ' + instances_str)

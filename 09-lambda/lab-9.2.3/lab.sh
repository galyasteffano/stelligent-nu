#!/bin/bash

# set -ex
aws_sl='aws-vault exec stelligent_labs -- aws'
export AWS_REGION=us-east-2
# $aws_sl s3 mb s3://lab-9-2-3-jdix

$aws_sl cloudformation package --template-file ./lambda-cfn.yaml --s3-bucket lab-9-2-3-jdix-cfn > ./lambda-cfn-packaged.yaml
# Uploading to 39decd859a08bdca2a75ef36d7d975c8  220 / 220.0  (100.00%)
# Resources:
#   MyApiMethod:
#     Type: AWS::ApiGateway::Method
#     Properties:
# ....

sed -i '' '1,1d' lambda-cfn-packaged.yaml

$aws_sl cloudformation deploy --stack-name lab-9-2-3-jdix --template-file lambda-cfn-packaged.yaml --capabilities CAPABILITY_NAMED_IAM

# $aws_sl s3 cp lab.sh s3://lab-9-2-3-jdix-mytesteventbucket

# $aws_sl cloudformation delete-stack --stack-name lab-9-2-3-jdix --region us-east-2

# python empty_bucket.py lab-9-2-3-jdix-cloudtrail && python empty_bucket.py lab-9-2-3-jdix-mytesteventbucket # && aws-sl cloudformation delete-stack --stack-name lab-9-2-3-jdix

# aws-sl s3 cp lab.sh s3://lab-9-2-3-jdix-mytesteventbucket/lab1.sh
# aws-sl s3 cp lab.sh s3://lab-9-2-3-jdix-mytesteventbucket/lab2.sh
# aws-sl s3 cp lab.sh s3://lab-9-2-3-jdix-mytesteventbucket/lab3.sh

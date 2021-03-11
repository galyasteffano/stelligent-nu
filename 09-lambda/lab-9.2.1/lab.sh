#!/bin/bash

# set -ex
aws_sl='aws-vault exec stelligent_labs -- aws'

# $aws_sl s3 mb s3://lab-9-1-3-jdix

$aws_sl cloudformation package --template-file ./lambda-cfn.yaml --s3-bucket lab-9-1-3-jdix > ./lambda-cfn-packaged.yaml
# Uploading to 39decd859a08bdca2a75ef36d7d975c8  220 / 220.0  (100.00%)
# Resources:
#   MyApiMethod:
#     Type: AWS::ApiGateway::Method
#     Properties:
# ....

sed -i '' '1,1d' lambda-cfn-packaged.yaml

$aws_sl cloudformation deploy --stack-name lab-9-1-3-jdix --template-file lambda-cfn-packaged.yaml --capabilities CAPABILITY_NAMED_IAM --region us-east-2
# $aws_sl cloudformation delete-stack --stack-name lab-9-1-3-jdix --region us-east-2


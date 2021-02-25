#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-3-1-jdix --capabilities CAPABILITY_NAMED_IAM

# aws-sl iam list-roles | grep jdix

$aws_sl sts assume-role --role-arn arn:aws:iam::324320755747:role/lab-3-3-1-jdix-MyRole-T2WMX3B34TRX --role-session-name su-lab-3-3-1-jdix

# add details to new profile named "sts_assumed_role" creds/profile and ran export AWS_PROFILE=sts_assumed_profile
# $ aws s3 mb s3://bob-bucket-unique-name-for-sure-1
# make_bucket: bob-bucket-unique-name-for-sure-1
# $ aws s3 mb s3://bob-bucket-unique-name-for-sure-2
# make_bucket: bob-bucket-unique-name-for-sure-2


$aws_sl cloudformation delete-stack --stack-name lab-3-3-1-jdix
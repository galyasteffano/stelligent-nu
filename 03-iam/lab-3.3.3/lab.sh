#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-3-3-jdix --capabilities CAPABILITY_NAMED_IAM

# aws-sl iam list-roles | grep jdix

$aws_sl sts assume-role --role-arn arn:aws:iam::324320755747:role/lab-3-3-3-jdix-MyRole-12G8YWX1YHNTH --role-session-name su-lab-3-3-3-jdix
                                                                                                
# lab-3-3-3-jdix-myfirstbucket-r5e3t2sqvi9k


# stelligent-nu) Joshua.Dix@workmac lab-3.3.3 % aws s3api put-object --bucket lab-3-3-3-jdix-myfirstbucket-r5e3t2sqvi9k --key lebowski/lab.sh --body lab.sh
# {
#     "ETag": "\"db8d6aa35d98f14544ec77861ba7a46f\""
# }
# (stelligent-nu) Joshua.Dix@workmac lab-3.3.3 % aws s3api put-object --bucket lab-3-3-3-jdix-myfirstbucket-r5e3t2sqvi9k --key lab.sh --body lab.sh 

# An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
# (stelligent-nu) Joshua.Dix@workmac lab-3.3.3 % 

# https://aws.amazon.com/premiumsupport/knowledge-center/emr-s3-403-access-denied/
$aws_sl cloudformation delete-stack --stack-name lab-3-3-3-jdix
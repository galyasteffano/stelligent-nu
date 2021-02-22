#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file simple-s3-user.cfn.yaml --stack-name su-lab-1-2-2 --capabilities CAPABILITY_NAMED_IAM

$aws_sl cloudformation list-exports

# $aws_sl cloudformation delete-stack --stack-name su-lab-1-2-2

#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file simple-s3.cfn.yaml --stack-name su-lab-1-1-2 --parameter-overrides BucketName=testbn-1-1-2

# $aws_sl cloudformation delete-stack --stack-name su-lab-1-1-2
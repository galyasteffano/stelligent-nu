#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-2-3-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3api put-object-acl --acl authenticated-read --bucket stelligent-u-josh-dix-labs --key data/private.txt

# $aws_sl cloudformation delete-stack --stack-name su-lab-2-2-3-jdix --region us-west-2

# try with a conditional
#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

# instructed to use 'same stack name' (don't think it matters)
$aws_sl cloudformation deploy --template-file simple-s3.cfn.yaml --stack-name su-lab-1-1-4

# $aws_sl cloudformation delete-stack --stack-name su-lab-1-1-4
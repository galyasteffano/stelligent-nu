#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-2-jdix --capabilities CAPABILITY_NAMED_IAM

$aws_sl cloudformation delete-stack --stack-name lab-3-1-2-jdix
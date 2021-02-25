#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-3-jdix --capabilities CAPABILITY_NAMED_IAM

echo "update, adding new role, reusing the managed policy"
# $aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-3-jdix --capabilities CAPABILITY_NAMED_IAM

echo "that failed, renaming the iam policy allowed it to work"
# $aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-3-jdix --capabilities CAPABILITY_NAMED_IAM

$aws_sl cloudformation delete-stack --stack-name lab-3-1-3-jdix
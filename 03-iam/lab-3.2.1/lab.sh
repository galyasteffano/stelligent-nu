#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-2-1-jdix --capabilities CAPABILITY_NAMED_IAM

# aws-sl iam list-roles | grep jdix

$aws_sl sts assume-role --role-arn arn:aws:iam::324320755747:role/lab-3-2-1-jdix-MyRole-1AV3LLXVMY55K --role-session-name su-lab-3-2-1-jdix

$aws_sl cloudformation delete-stack --stack-name lab-3-2-1-jdix
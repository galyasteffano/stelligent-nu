#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-1-jdix --capabilities CAPABILITY_NAMED_IAM

$aws_sl iam list-roles

# $aws_sl iam list-roles | grep jdix

$aws_sl iam get-role --role-name lab-3-1-1-jdix-MyRole-1NFTKG9DK7AKX

$aws_sl cloudformation delete-stack --stack-name lab-3-1-1-jdix
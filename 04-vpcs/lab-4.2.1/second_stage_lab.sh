#!/bin/bash

export AWS_PAGER=

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn/east_peering.yaml --stack-name vpc-peering-lab-4-2-1 --parameter-overrides file://params/peering_params.json --region us-east-2

# $aws_sl cloudformation delete-stack --stack-name vpc-peering-lab-4-2-1 --region us-east-2
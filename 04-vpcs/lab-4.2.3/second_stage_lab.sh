#!/bin/bash

export AWS_PAGER=

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn/east_peering.yaml --stack-name vpc-peering-lab-4-2-1 --parameter-overrides file://params/peering_params.json --region us-east-2

# $aws_sl cloudformation delete-stack --stack-name vpc-peering-lab-4-2-1 --region us-east-2

$aws_sl cloudformation deploy --template-file cfn/west_vpc.yaml --stack-name west-vpc-lab-4-2-1 --parameter-overrides file://params/west_vpc_params.json --region us-west-2


# √ Downloads % jq -r '.prefixes[] | select(.service=="S3" and .region=="us-west-2") | .ip_prefix' < ip-ranges.json
# 3.5.76.0/22
# 3.5.80.0/21
# 52.218.128.0/17
# 52.92.128.0/17
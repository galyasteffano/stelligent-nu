#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

if [ -z $1 ];
then
    echo "using default region"
    region_string=""
else
    echo "using set region $1"
    region_string="--region $1"
fi

echo "$aws_sl cloudformation deploy --template-file simple-s3.cfn.yaml --stack-name su-lab-1-1-4 $region_string"
$aws_sl cloudformation deploy --template-file simple-s3.cfn.yaml --stack-name su-lab-1-1-4 $region_string

# $aws_sl cloudformation delete-stack --stack-name su-lab-1-1-4
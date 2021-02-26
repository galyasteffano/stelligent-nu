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

$aws_sl cloudformation deploy --template-file simple-s3.cfn.yaml --stack-name su-lab-1-1-5 $region_string

sleep 10

$aws_sl cloudformation update-termination-protection --stack-name su-lab-1-1-5 --enable-termination-protection $region_string

$aws_sl cloudformation delete-stack --stack-name su-lab-1-1-5

# An error occurred (ValidationError) when calling the DeleteStack operation: Stack [su-lab-1-1-5] cannot be deleted while TerminationProtection is enabled

$aws_sl cloudformation update-termination-protection --stack-name su-lab-1-1-5 --no-enable-termination-protection $region_string

$aws_sl s3 ls | grep jdix

$aws_sl cloudformation delete-stack --stack-name su-lab-1-1-5 $region_string

sleep 10

$aws_sl s3 ls | grep jdix
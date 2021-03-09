#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
export AWS_PAGER=''
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-5-3-4-jdix'

ding_ding_ding="
DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE
DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE
DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE-DONE
"

if [ $1 == 'up' ]; then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM
    $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    echo $ding_ding_ding
elif [ $1 == 'down' ]; then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $ding_ding_ding
fi

#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-10-1-1-jdix-cwinfra'
done="DONE"


if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --capabilities CAPABILITY_NAMED_IAM
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi
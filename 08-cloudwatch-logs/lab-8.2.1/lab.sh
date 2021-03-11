#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
cw_stack_name='lab-8-1-2-jdix-cwinfra'
res_stack_name='lab-8-1-2-jdix-instance'
done="DONE"


if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $cw_stack_name --template-file cw-infra.yaml --parameter-overrides file://vpc_params.json --region us-east-2 --capabilities CAPABILITY_NAMED_IAM
    # $aws_sl cloudformation deploy --stack-name $res_stack_name --template-file res.yaml --region us-east-2 --capabilities CAPABILITY_NAMED_IAM
    echo $done
elif [ $1 == 'down' ]
then
    # $aws_sl cloudformation delete-stack --stack-name $res_stack_name --region us-east-2
    # $aws_sl cloudformation wait stack-delete-complete --stack-name $res_stack_name
    $aws_sl cloudformation delete-stack --stack-name $cw_stack_name --region us-east-2
    $aws_sl cloudformation wait stack-delete-complete --stack-name $cw_stack_name
    echo $done
fi


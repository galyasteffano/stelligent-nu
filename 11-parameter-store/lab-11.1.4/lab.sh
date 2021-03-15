#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
export AWS_PAGER=''
export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-11-1-3-jdix'
done="DONE"

if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file lb.yaml --parameter-overrides file://lb-params.json --capabilities CAPABILITY_NAMED_IAM
    # $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    # $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi

# aws ssm get-parameter --name /joshdix/middle-name --region us-east-2 | jq -r '.Parameter.Value' > param_middle-name_secret.txt
# aws ssm get-parameter --name /joshdix/middle-name --region us-east-2 --with-decryption
# set kms key policy to allow role by name (required after creation through console?)
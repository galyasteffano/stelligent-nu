#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-7-1-3-jdix'
done="DONE"

if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM
    # $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    # $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi


# openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
# openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12
# aws-sl acm import-certificate --certificate fileb://certificate.pem --private-key fileb://key.pem --region us-east-2
# {
#     "CertificateArn": "arn:aws:acm:us-east-2:324320755747:certificate/d3993eb8-054b-4657-bb2b-403434a61781"
# }

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

# aws-sl  kms create-key     
# {
#     "KeyMetadata": {
#         "AWSAccountId": "324320755747",
#         "KeyId": "5977cef3-e5e5-4fba-b044-69f30fb375eb",
#         "Arn": "arn:aws:kms:us-east-2:324320755747:key/5977cef3-e5e5-4fba-b044-69f30fb375eb",
#         "CreationDate": "2021-03-11T18:26:17.989000-05:00",
#         "Enabled": true,
#         "Description": "",
#         "KeyUsage": "ENCRYPT_DECRYPT",
#         "KeyState": "Enabled",
#         "Origin": "AWS_KMS",
#         "KeyManager": "CUSTOMER",
#         "CustomerMasterKeySpec": "SYMMETRIC_DEFAULT",
#         "EncryptionAlgorithms": [
#             "SYMMETRIC_DEFAULT"
#         ]
#     }
# }
# aws-sl  kms create-alias --alias-name alias/joshdixkey --target-key-id 5977cef3-e5e5-4fba-b044-69f30fb375eb

# aws-sl ssm put-parameter --name /joshdix/middle-name --key-id alias/joshdixkey --value ryan --type SecureString
# {
#     "Version": 1,
#     "Tier": "Standard"
# }

# ./lab.sh up
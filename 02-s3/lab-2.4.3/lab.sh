#!/bin/bash

export AWS_PAGER=

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-4-3-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3 cp ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2 --recursive

$aws_sl s3api get-object --bucket stelligent-u-josh-dix-labs --key data/private.txt /dev/null

# aws-sl kms create-key --region us-west-2                           
# {
#     "KeyMetadata": {
#         "AWSAccountId": "324320755747",
#         "KeyId": "90035765-7fa4-4702-b4e1-98615069bcaa",
#         "Arn": "arn:aws:kms:us-west-2:324320755747:key/90035765-7fa4-4702-b4e1-98615069bcaa",
#         "CreationDate": "2021-02-24T20:53:28.651000-05:00",
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

# aws-sl kms create-alias --alias-name alias/su-lab-2-4-3-jdix --target-key-id 90035765-7fa4-4702-b4e1-98615069bcaa --region us-west-2

$aws_sl s3 cp ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2 --recursive --sse-kms-key-id arn:aws:kms:us-west-2:324320755747:key/90035765-7fa4-4702-b4e1-98615069bcaa --sse aws:kms

# just repeated with alias usage
$aws_sl s3 cp ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2 --recursive --sse-kms-key-id alias/su-lab-2-4-3-jdix --sse aws:kms

$aws_sl s3api get-object --bucket stelligent-u-josh-dix-labs --key data/private.txt /dev/null

# python empty_bucket.py stelligent-u-josh-dix-labs
# aws-sl cloudformation delete-stack --stack-name su-lab-2-4-3-jdix --region us-west-2
# aws-sl kms disable-key --key-id 90035765-7fa4-4702-b4e1-98615069bcaa
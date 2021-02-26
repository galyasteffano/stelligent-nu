#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

# policy tester

aws-sl iam list-policies --scope Local | grep s3_reader # get arn / "default" version
aws-sl iam get-policy-version --policy-arn arn:aws:iam::324320755747:policy/s3_reader_user_lab_1_2_2_jdix --version-id v1
# copy policy to ./s3_read_policy.json (format as json "string") https://stackoverflow.com/questions/47861141/aws-cli-simulate-custom-policy-newbie-basic-s3-call

$aws_sl iam simulate-custom-policy --policy-input-list file://s3_read_policy.json --resource-arn "arn:aws:s3:::324320755747--cft" --caller-arn "arn:aws:iam::324320755747:user/s3_reader_user_lab_1_2_3_jdix" --action-names "s3:GetObject" "s3:PutObject"

# ssm parameter store completed in lab-1.2.2 folder - copied below:
# Resources:
#   s3ReaderPolicy:
#     Type: AWS::IAM::ManagedPolicy
#     Properties:
#       ManagedPolicyName: s3_reader_user_lab_1_2_2_jdix
#       Path: '/'
#       PolicyDocument:
#         Version: '2012-10-17'
#         Statement:
#         - Effect: Allow
#           Action:
#           - s3:GetObject
#           - s3:ListAllMyBuckets
#           Resource: '*'
#   s3User:
#     Type: AWS::IAM::User
#     Properties:
#       Path: "/"
#       UserName: '{{resolve:ssm:su-retro-1-2-jdix:1}}' 
#       ManagedPolicyArns:
#         - Ref: s3ReaderPolicy
# Outputs:
#   s3ReaderPolicy:
#     Value: !Ref s3ReaderPolicy
#     Description: "this is for a lab"
#     Export:
#       Name: "lab-2-1-2-s3ReaderPolicyArn-jdix"
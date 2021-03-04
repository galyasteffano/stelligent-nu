#!/bin/bash

export AWS_REGION=us-east-2
export AWS_PAGER=''
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-5-1-2-jdix'


# aws-sl ec2 describe-images --owners self amazon --filters "Name=root-device-type,Values=ebs" "Name=platform,Values=windows" "Name=name,Values=*2016*English*Base*" --query 'Images[*].[ImageId, Name][20:30]'
# [
#     "ami-02f50d6aef81e691a",
#     "Windows_Server-2016-English-Full-Base-2021.02.10"
# ],
# aws-sl ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd*" --query "sort_by(Images, &CreationDate)[].[Name, ImageId]"
# [
#     "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20210224-d83d0782-cb94-46d7-8993-f4ce15d1a484",
#     "ami-037c234ac9f2dab36"
# ],

# $aws_sl cloudformation delete-stack --stack-name $stack_name
# $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name

$aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json

$aws_sl cloudformation wait stack-create-complete --stack-name $stack_name

$aws_sl cloudformation describe-stacks --stack-name $stack_name

$aws_sl cloudformation describe-stack-resources --stack-name $stack_name
#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-1-5-jdix --capabilities CAPABILITY_NAMED_IAM

# role 1
$aws_sl iam simulate-principal-policy --policy-source-arn arn:aws:iam::324320755747:role/lab-3-1-5-jdix-MyRole-1O5SVTUUMMO6G --action-names iam:CreateRole iam:ListRoles iam:SimulatePrincipalPolicy ec2:DescribeImages ec2:RunInstances ec2:DescribeSecurityGroups
# role 2
$aws_sl iam simulate-principal-policy --policy-source-arn arn:aws:iam::324320755747:role/lab-3-1-5-jdix-MySecondRole-IWEBRRVE102V --action-names iam:CreateRole iam:ListRoles iam:SimulatePrincipalPolicy ec2:DescribeImages ec2:RunInstances ec2:DescribeSecurityGroups

$aws_sl cloudformation delete-stack --stack-name lab-3-1-5-jdix
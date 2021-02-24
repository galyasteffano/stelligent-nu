#!/bin/bash

export AWS_PAGER=

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-3-3-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3 sync ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

$aws_sl s3api get-bucket-tagging --bucket stelligent-u-josh-dix-labs
$aws_sl s3api put-bucket-tagging --bucket stelligent-u-josh-dix-labs --tagging 'TagSet=[{Key=aws:cloudformation:stack-id,Value=arn:aws:cloudformation:us-west-2:324320755747:stack/su-lab-2-3-3-jdix/25e06440-76ab-11eb-81bc-06e6d1ac322b},{Key=aws:cloudformation:stack-name,Value=su-lab-2-3-3-jdix},{Key=aws:cloudformation:logical-id,Value=MyBucket},{Key=testk,Value=testv},{Key=Name,Value=myTag}]'
$aws_sl s3api get-bucket-tagging --bucket stelligent-u-josh-dix-labs

# python empty_bucket.py stelligent-u-josh-dix-labs
# aws-sl cloudformation delete-stack --stack-name su-lab-2-3-3-jdix --region us-west-2
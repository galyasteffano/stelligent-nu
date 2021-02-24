#!/bin/bash

export AWS_PAGER=

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-4-2-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3 sync ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

# python empty_bucket.py stelligent-u-josh-dix-labs
# aws-sl cloudformation delete-stack --stack-name su-lab-2-4-2-jdix --region us-west-2
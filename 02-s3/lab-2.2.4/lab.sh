#!/bin/bash

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-2-3-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2
$aws_sl s3 sync ../lab-2.2.1/data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

# $aws_sl s3api put-object-acl --acl authenticated-read --bucket stelligent-u-josh-dix-labs --key data/private.txt

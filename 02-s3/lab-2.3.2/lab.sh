#!/bin/bash

export AWS_PAGER=

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-2-3-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2
$aws_sl s3 sync ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

echo "making changes to data files"
echo "changes" >> ./data/private.txt
echo "changes" >> ./data/t1.txt
echo "changes" >> ./data/t2.txt
echo "changes" >> ./data/t3.txt
echo "changes" >> ./data/t4.txt

echo "updating bucket data files"
$aws_sl s3 sync ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

echo "getting a list of versions for t1"
$aws_sl s3api list-object-versions --bucket stelligent-u-josh-dix-labs --prefix data/t1.txt

# aws-sl cloudformation delete-stack --stack-name su-lab-2-2-3-jdix --region us-west-2
# python empty_bucket.py stelligent-u-josh-dix-labs
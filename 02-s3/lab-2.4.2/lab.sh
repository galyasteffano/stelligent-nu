#!/bin/bash

export AWS_PAGER=

# was already using mostly cfn, but this is a little better!

aws_sl='aws-vault exec stelligent_labs -- aws'


$aws_sl s3 sync ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2

$aws_sl cloudformation deploy --template-file ../lab-2.4.1/policy.cfn.yaml --stack-name su-lab-2-4-2-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3 cp ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2 --recursive
$aws_sl s3api get-object --bucket stelligent-u-josh-dix-labs --key data/private.txt /dev/null

# {
#     "AcceptRanges": "bytes",
#     "LastModified": "2021-02-24T20:42:21+00:00",
#     "ContentLength": 100,
#     "ETag": "\"828c216a75f217c46aa2b6054bf6994e\"",
#     "VersionId": "HyBVG0VeTkI9c4kCUJoiUP1skpvS.a6K",
#     "ContentType": "text/plain",
#     "ServerSideEncryption": "AES256",
#     "Metadata": {}
# }

$aws_sl cloudformation deploy --template-file policy.cfn.yaml --stack-name su-lab-2-4-2-jdix --capabilities CAPABILITY_NAMED_IAM --region us-west-2

$aws_sl s3 cp ./data s3://stelligent-u-josh-dix-labs/data/ --region us-west-2 --recursive
$aws_sl s3api get-object --bucket stelligent-u-josh-dix-labs --key data/private.txt /dev/null

# {
#     "AcceptRanges": "bytes",
#     "LastModified": "2021-02-24T20:11:08+00:00",
#     "ContentLength": 100,
#     "ETag": "\"91222fab8654a7ef2c1af1b94ba13fb4\"",
#     "VersionId": "WOjGZzLTO2fmpbuh7_tvcAclArGvyzR4",
#     "ContentType": "text/plain",
#     "ServerSideEncryption": "aws:kms",
#     "Metadata": {},
#     "SSEKMSKeyId": "arn:aws:kms:us-west-2:324320755747:key/6adc2c83-1b8f-47b4-802c-ef02fde3615c",
#     "BucketKeyEnabled": true
# }

# python empty_bucket.py stelligent-u-josh-dix-labs
# aws-sl cloudformation delete-stack --stack-name su-lab-2-4-2-jdix --region us-west-2
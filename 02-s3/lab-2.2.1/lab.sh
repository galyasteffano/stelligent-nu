#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl s3api create-bucket --bucket stelligent-u-josh-dix-labs --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

$aws_sl s3 sync . s3://stelligent-u-josh-dix-labs --region us-west-2 --exclude "lab.sh" --acl "public-read"

$aws_sl s3api list-objects --bucket stelligent-u-josh-dix-labs --region us-west-2

mkdir data_download
aws s3 cp s3://stelligent-u-josh-dix-labs/data/private.txt ./data_download/
# fatal error: An error occurred (403) when calling the HeadObject operation: Forbidden
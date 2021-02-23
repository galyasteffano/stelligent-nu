#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl s3 rb s3://stelligent-u-josh-dix-labs --region us-west-2
# remove_bucket failed: s3://stelligent-u-josh-dix-labs An error occurred (BucketNotEmpty) when calling the DeleteBucket operation: The bucket you tried to delete is not empty

$aws_sl s3 rb s3://stelligent-u-josh-dix-labs --force --region us-west-2


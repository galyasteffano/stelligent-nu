#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

# $aws_sl s3api create-bucket --bucket stelligent-u-josh-dix-labs --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

$aws_sl s3 cp . s3://stelligent-u-josh-dix-labs --region us-west-2 --exclude "*secret*" --exclude "*lab.sh*" --recursive

$aws_sl s3api list-objects --bucket stelligent-u-josh-dix-labs --region us-west-2 | grep secret

#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl s3api put-object-acl --acl bucket-owner-read --bucket stelligent-u-josh-dix-labs --key data/private.txt
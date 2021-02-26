#!/bin/bash

aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation delete-stack --stack-name su-lab-1-2-2
$aws_sl cloudformation describe-stacks --stack-name su-lab-1-2-2 # shows error

$aws_sl cloudformation delete-stack --stack-name su-lab-1-2-3
sleep 3
$aws_sl cloudformation delete-stack --stack-name su-lab-1-2-2
#!/bin/bash

export AWS_PAGER=
aws_sl='aws-vault exec stelligent_labs -- aws'

$aws_sl cloudformation deploy --template-file cfn.yaml --stack-name lab-3-3-3-jdix --capabilities CAPABILITY_NAMED_IAM

# aws-sl iam list-roles | grep jdix

$aws_sl sts assume-role --role-arn <ROLE> --role-session-name su-lab-3-3-3-jdix

# $ aws s3 cp lab.sh s3://lab-3-3-3-jdix-mysecondbucket-wjagutupkbms
# upload failed: ./lab.sh to s3://lab-3-3-3-jdix-mysecondbucket-wjagutupkbms/lab.sh An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
# jdix@~/git_repos/stelligent-nu/03-iam/lab-3.3.2
# $ aws s3 cp lab.sh s3://lab-3-3-3-jdix-myfirstbucket-7clcyx0z351q
# upload: ./lab.sh to s3://lab-3-3-3-jdix-myfirstbucket-7clcyx0z351q/lab.sh


$aws_sl cloudformation delete-stack --stack-name lab-3-3-3-jdix
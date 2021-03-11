#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-8-1-1-jdix'
done="DONE"

if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM
    # $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    # $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi

aws-sl logs create-log-group --log-group-name josh.dix.c9logs 
aws-sl logs create-log-stream --log-group-name josh.dix.c9logs --log-stream-name c9.training

# aws-sl logs describe-log-groups                                                                            
# {
#     "logGroups": [
#         {
#             "logGroupName": "/var/log/syslog",
#             "creationTime": 1614868098701,
#             "metricFilterCount": 0,
#             "arn": "arn:aws:logs:us-east-2:324320755747:log-group:/var/log/syslog:*",
#             "storedBytes": 53740
#         },
#         {
#             "logGroupName": "josh.dix.c9logs",
#             "creationTime": 1615296476938,
#             "metricFilterCount": 0,
#             "arn": "arn:aws:logs:us-east-2:324320755747:log-group:josh.dix.c9logs:*",
#             "storedBytes": 0
#         }
#     ]
# }

# aws-sl logs describe-log-streams --log-group-name josh.dix.c9logs
# {
#     "logStreams": [
#         {
#             "logStreamName": "c9.training",
#             "creationTime": 1615296571174,
#             "arn": "arn:aws:logs:us-east-2:324320755747:log-group:josh.dix.c9logs:log-stream:c9.training",
#             "storedBytes": 0
#         }
#     ]
# }
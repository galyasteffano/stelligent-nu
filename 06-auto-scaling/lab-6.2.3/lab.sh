#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
export AWS_PAGER=''
export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
stack_name='lab-6-2-3-jdix'

done="DONE"

if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]] ; then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]; then
    $aws_sl cloudformation deploy --stack-name $stack_name --template-file cfn.yaml --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM
    # $aws_sl cloudformation wait stack-create-complete --stack-name $stack_name
    echo $done
elif [ $1 == 'down' ]; then
    $aws_sl cloudformation delete-stack --stack-name $stack_name
    $aws_sl cloudformation wait stack-delete-complete --stack-name $stack_name
    echo $done
fi

# aws-sl autoscaling describe-auto-scaling-groups --query '[AutoScalingGroups][][Instances][][][InstanceId]'

# aws-sl autoscaling detach-instances --instance-ids i-09674834cb09950b6 --auto-scaling-group-name "lab-6-2-3-jdix-MyAsg-IDVX3C9EDBP" --no-should-decrement-desired-capacity
# {
#     "Activities": [
#         {
#             "ActivityId": "4785e00f-936e-2898-b67a-b0fecda81ff4",
#             "AutoScalingGroupName": "lab-6-2-3-jdix-MyAsg-IDVX3C9EDBP",
#             "Description": "Detaching EC2 instance: i-09674834cb09950b6",
#             "Cause": "At 2021-03-05T19:37:13Z instance i-09674834cb09950b6 was detached in response to a user request.",
#             "StartTime": "2021-03-05T19:37:13.354000+00:00",
#             "StatusCode": "InProgress",
#             "Progress": 50,
#             "Details": "{\"Subnet ID\":\"subnet-08a3dc1b3555a3021\",\"Availability Zone\":\"us-east-2a\"}"
#         }
#     ]
# }

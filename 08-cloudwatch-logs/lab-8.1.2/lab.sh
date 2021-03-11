#!/bin/bash

# set -ex

export AWS_REGION=us-east-2
# export AWS_PAGER=''
# export AWS_VAULT_PROMPT=terminal
aws_sl='aws-vault exec stelligent_labs -- aws'
vpc_stack_name='lab-8-1-2-jdix-vpc'
instance_stack_name='lab-8-1-2-jdix-instance'
done="DONE"

# declare -A east1_vpc_stack
# east_vpc_stack[yaml]=vpc.yaml
# east_vpc_stack[region]=us-east-1
# east_vpc_stack[parameters]=params.json
# east_vpc_stack[CAPABILITY_NAMED_IAM]=true

# declare -A east1_vpc_stack
# east_vpc_stack[yaml]=vpc.yaml
# east_vpc_stack[region]=us-east-1
# east_vpc_stack[parameters]=params.json
# east_vpc_stack[CAPABILITY_NAMED_IAM]=true

# declare -A east1_vpc_stack
# east_vpc_stack[yaml]=vpc.yaml
# east_vpc_stack[region]=us-east-1
# east_vpc_stack[parameters]=params.json
# east_vpc_stack[CAPABILITY_NAMED_IAM]=true

# declare -A east1_vpc_stack
# east_vpc_stack[yaml]=vpc.yaml
# east_vpc_stack[region]=us-east-1
# east_vpc_stack[parameters]=params.json
# east_vpc_stack[CAPABILITY_NAMED_IAM]=true

# declare -A east1_vpc_stack
# east_vpc_stack[yaml]=vpc.yaml
# east_vpc_stack[region]=us-east-1
# east_vpc_stack[parameters]=params.json
# east_vpc_stack[CAPABILITY_NAMED_IAM]=true


# stack_arr=(
    
# )


if [[ -z $1 || ( $1 != 'up' && $1 != 'down' ) ]]
then
    echo 'up or down'
    exit 1
fi

if [ $1 == 'up' ]
then
    $aws_sl cloudformation deploy --stack-name $vpc_stack_name --template-file vpc.yaml --parameter-overrides file://vpc_params.json --region us-east-2
    $aws_sl cloudformation deploy --stack-name $instance_stack_name --template-file 8.1.2.yaml --region us-east-2 --capabilities CAPABILITY_NAMED_IAM &
    echo $done
elif [ $1 == 'down' ]
then
    $aws_sl cloudformation delete-stack --stack-name $instance_stack_name --region us-east-2
    $aws_sl cloudformation wait stack-delete-complete --stack-name $instance_stack_name
    $aws_sl cloudformation delete-stack --stack-name $vpc_stack_name --region us-east-2
    echo $done
fi


# aws-sl logs create-log-group --log-group-name josh.dix.c9logs 
# aws-sl logs create-log-stream --log-group-name josh.dix.c9logs --log-stream-name c9.training

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



# aws-sl s3 mb s3://lab-8-1-2-jdix --region us-east-2
# make_bucket: lab-8-1-2-jdix

# aws-sl s3 cp cloudwatch_template.txt s3://lab-8-1-2-jdix --region us-east-2 
# upload: ./cloudwatch_template.txt to s3://lab-8-1-2-jdix/cloudwatch_template.txt

# aws-sl s3api put-object-acl --acl public-read --bucket lab-8-1-2-jdix --key cloudwatch_template.txt --region us-east-2
# https://lab-8-1-2-jdix.s3.us-east-2.amazonaws.com/cloudwatch_template.txt

# curl https://lab-8-1-2-jdix.s3.us-east-2.amazonaws.com/cloudwatch_template.txt --output config.json 


# aws-sl logs get-log-events --log-group-name josh.dix.c9logs --log-stream-name c9.training
# ...^...
#         {
#             "timestamp": 1615317155734,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 ec2: #############################################################",
#             "ingestionTime": 1615317160855
#         },
#         {
#             "timestamp": 1615317155734,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 cloud-init[1719]: Cloud-init v. 18.3-9-g2e62cb8a-0ubuntu1~16.04.2 running 'modules:final' at Tue, 09 Mar 2021 19:12:07 +0000. Up 19.96 seconds.",
#             "ingestionTime": 1615317160855
#         },
#         {
#             "timestamp": 1615317155734,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 cloud-init[1719]: Cloud-init v. 18.3-9-g2e62cb8a-0ubuntu1~16.04.2 finished at Tue, 09 Mar 2021 19:12:35 +0000. Datasource DataSourceEc2Local.  Up 47.21 seconds",
#             "ingestionTime": 1615317160855
#         },
#         {
#             "timestamp": 1615317155734,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 systemd[1]: Started Execute cloud user/final scripts.",
#             "ingestionTime": 1615317160855
#         },
#         {
#             "timestamp": 1615317155734,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 systemd[1]: Reached target Cloud-init target.",
#             "ingestionTime": 1615317160855
#         },
#         {
#             "timestamp": 1615317160815,
#             "message": "Mar  9 19:12:35 ip-10-20-0-27 systemd[1]: Startup finished in 5.350s (kernel) + 41.962s (userspace) = 47.313s.",
#             "ingestionTime": 1615317165875
#         },
#         {
#             "timestamp": 1615317186728,
#             "message": "Mar  9 19:13:02 ip-10-20-0-27 amazon-ssm-agent.amazon-ssm-agent[1655]: 2021-03-09 19:13:02 INFO [instanceID=i-058f8cf46f47fdc99] [MessagingDeliveryService] [Association] Schedule manager refreshed with 0 associations, 0 new assocations associated",
#             "ingestionTime": 1615317191765
#         },
#         {
#             "timestamp": 1615317200728,
#             "message": "Mar  9 19:13:16 ip-10-20-0-27 amazon-ssm-agent.amazon-ssm-agent[1655]: 2021-03-09 19:13:16 INFO [HealthCheck] HealthCheck reporting agent health.",
#             "ingestionTime": 1615317205744
#         }
#     ],
#     "nextForwardToken": "f/36022777308238872793723772464093008386915615936688750592",
#     "nextBackwardToken": "b/36022776304705338859845731040718102998574807653183258624"
# }

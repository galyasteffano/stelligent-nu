#!/bin/bash
# aws_sl='aws-vault exec stelligent_labs -- aws'

# aws_regions=( $(jq -r '.[][]' regions.json) )

# if [[ ! -z $1 ]] && [[ $1 == 'up' || $1 == 'down' ]]; then
#     for region in ${aws_regions[@]}; do
#     region_prefix=su-lab-$region-1-3-1

#     if [ $1 == 'up' ]; then
#         $aws_sl cloudformation deploy --template-file simple-s3-user.cfn.yaml --stack-name $region_prefix-stack --parameter-overrides FriendlyName=joe-bucket --region $region
#     elif [ $1 == 'down' ]; then
#         $aws_sl cloudformation delete-stack --stack-name $region_prefix-stack --region $region
#     fi
#     done
# else
#     echo "please set \$1 to 'up' or 'down' to spin stacks up or down."
#     exit 1
# fi

import boto3
import json
import sys

"""
USAGE deploy.py FRIENDLY_NAME
FRIENDLY_NAME is a tag for buckets and stacks to relate to project.
"""

FRIENDLY_NAME="friend-joe"

try:
    FRIENDLY_NAME = sys.argv[1]
# except KeyError as e:
except IndexError as e:
    pass

JSON_REGIONS_FILE = "./01-cloudformation/lab-1.3.2/regions.json"
with open(JSON_REGIONS_FILE, 'r') as conf_file:
    REGIONS_TO_USE = json.loads(conf_file.read())["Regions"]

session = boto3.Session()
ACCOUNT_ID = "324320755747"

for region in REGIONS_TO_USE:
    # if stack exists, update it
    STACK_NAME = '-'.join(["stack", ACCOUNT_ID, region, FRIENDLY_NAME])
    BUCKET_NAME = '-'.join(["bucket", ACCOUNT_ID, region, FRIENDLY_NAME])
    
    cloudformations_client = session.client('cloudformation', region_name=region)

    paginator = cloudformations_client.get_paginator('list_stacks')
    for page in paginator.paginate():
        for stack in page['StackSummaries']:
            if stack['StackStatus'] == 'DELETE_COMPLETE':
                continue
            if stack['StackName'] == STACK_NAME:
                stack_exists = True
    
    if stack_exists:
        cloudformations_client.update_stack()

    print('hold')
    cloudformations_client.create_stack(json.loads(open('simple-s3.cfn.yaml')))
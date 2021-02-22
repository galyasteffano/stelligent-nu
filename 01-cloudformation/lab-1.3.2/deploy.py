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

JSON_REGIONS_FILE = "/home/jdix/git_repos/stelligent-nu/01-cloudformation/lab-1.3.2/regions.json"

with open(JSON_REGIONS_FILE, 'r') as conf_file:
    regions = json.loads(conf_file.read())["Regions"]

for region in regions:
    cloudformations_client = boto3.client('cloudformation')
    print('hold')
    cloudformations_client
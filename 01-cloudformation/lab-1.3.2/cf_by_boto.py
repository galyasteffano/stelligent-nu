import json
import sys
import os
import boto3

sys.path.append(os.path.dirname(__file__))
import gist

"""
USAGE deploy.py <UP|DOWN>
FRIENDLY_NAME is a tag for buckets and stacks to relate to project.
"""

JSON_REGIONS_FILE = "./01-cloudformation/lab-1.3.2/regions.json"
with open(JSON_REGIONS_FILE, 'r') as conf_file:
    REGIONS_TO_USE = json.loads(conf_file.read())["Regions"]

# session = boto3.Session()
ACCOUNT_ID = "324320755747"

for region in REGIONS_TO_USE:
    # if stack exists, update it
    STACK_NAME = '-'.join(["stack", ACCOUNT_ID, region])
    BUCKET_NAME = '-'.join(["bucket", ACCOUNT_ID, region])

    cf = boto3.client('cloudformation', region_name=region)

    try:
        if sys.argv[1] == 'up' or sys.argv[1] == 'down':
            # name, template, parameters file, region, state
            gist.deploy(STACK_NAME, './01-cloudformation/lab-1.3.2/simple-s3-user.cfn.yaml', './01-cloudformation/lab-1.3.2/parameters.json', region, sys.argv[1])
        else:
            print('enter (up|down) as $1')
            sys.exit(1)
    except:
        print('enter (up|down) as $1')
        sys.exit(1)
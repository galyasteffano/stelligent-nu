import os
import first_stage_stacks, crud_cfn_stack # pyright: reportMissingImports=false

"""
creates / updates / deletes stacks
uses code generation through toposphere
allows the optional use of parameter files laid out as:
[
    {
        "ParameterKey": "FriendlyName",
        "ParameterValue": "friend-bob",
        "UsePreviousValue": false,
        "ResolvedValue": ""
    }
]
# get latest ami in a region
aws-sl ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-xxxx-x

"""

state = 'up'
# state = sys.argv[1]
os.environ['AWS_PROFILE'] = 'stelligent_labs_temp'

# stacks that can be built in order, assuming an earlier might rely on a later one.
stacks_in_order = [
    {
        "stack_name": "east-vpc-lab-4-2-1",
        "stack_yaml": "cfn/east_vpc.yaml",
        "stack_params": "params/east_vpc_params.json",
        "stack_func": first_stage_stacks.east_vpc_stack,
        "stack_region": "us-east-2"
    },
    {
        "stack_name": "east-instances-lab-4-2-1",
        "stack_yaml": "cfn/east_instance.yaml",
        "stack_params": "params/east_instance_params.json",
        "stack_func": first_stage_stacks.east_instance_stack,
        "stack_region": "us-east-2"
    },
    {
        "stack_name": "west-vpc-lab-4-2-1",
        "stack_yaml": "cfn/west_vpc.yaml",
        "stack_params": "params/west_vpc_params.json",
        "stack_func": first_stage_stacks.west_vpc_stack,
        "stack_region": "us-west-2"
    },
    {
        "stack_name": "west-instances-lab-4-2-1",
        "stack_yaml": "cfn/west_instance.yaml",
        "stack_params": "params/west_instance_params.json",
        "stack_func": first_stage_stacks.west_instance_stack,
        "stack_region": "us-west-2"
    }
]

if state == 'down':
    stacks_in_order = reversed(stacks_in_order)

for stack in stacks_in_order:
    stack['stack_func'](stack['stack_yaml'])
    # name, template, parameters file, region, state
    crud_cfn_stack.deploy(stack['stack_name'], stack['stack_yaml'], stack['stack_params'], stack['stack_region'], state)

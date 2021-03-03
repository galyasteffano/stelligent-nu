import sys, os
import botocore
import cfn_generator, crud_cfn_stack # pyright: reportMissingImports=false
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
"""

region = 'us-east-2'
state = 'down'
# state = sys.argv[1]
os.environ['AWS_PROFILE'] = 'stelligent_labs_temp'

# stacks that can be built in order, assuming an earlier might rely on a later one.

stacks_in_order = [
    {
        "stack_name": 'base-lab-4-1-8',
        "stack_yaml": 'cfn-base.yaml',
        "stack_params": 'cidr_params.json',
        "stack_func": cfn_generator.dump_base_yaml
    },
    {
        "stack_name": 'lab-4-1-8',
        "stack_yaml": 'cfn-lab.yaml',
        "stack_params": 'instance_params.json',
        "stack_func": cfn_generator.dump_lab_yaml
    }
]

if state == 'down':
    stacks_in_order = reversed(stacks_in_order)

for stack in stacks_in_order:
    stack['stack_func'](stack['stack_yaml'])
    # name, template, parameters file, region, state
    crud_cfn_stack.deploy(stack['stack_name'], stack['stack_yaml'], stack['stack_params'], region, state)

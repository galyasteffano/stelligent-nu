import sys, os
import cfn_generator, crud_cfn_stack # pyright: reportMissingImports=false

cfn_generator.dump_yaml('cfn.yaml')

region = 'us-east-2'
stack_name = 'lab-4-1-2'

# pulled the below from my launch file for transparency (and so i don't need to copy an already cluttered workspace)
state = 'down'
# state = sys.argv[1]
os.environ['AWS_PROFILE'] = 'stelligent_labs_temp'

try:
    if state == 'up' or state == 'down':
        # name, template, parameters file, region, state
        crud_cfn_stack.deploy(stack_name, './cfn.yaml', './cidr_params.json', region, state)
    else:
        print('enter (up|down) as $1')
        sys.exit(1)
except:
    print('enter (up|down) as $1')
    sys.exit(1)
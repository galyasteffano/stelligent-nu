import os
# prevents bools showing up as strings
os.environ['TROPO_REAL_BOOL'] = 'true'

from troposphere import Ref, Template, Tags, Sub, Select, GetAZs, Parameter, Output
import troposphere.ec2 as ec2

def dump_yaml(cfn_file):

    template = Template()

    vpc_cidr_param = template.add_parameter(Parameter(
        "vpcCidrParam",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    subnet_cidr_param = template.add_parameter(Parameter(
        "subnetCidrParam",
        Description="string of subnet cidr block to use",
        Type="String",
    ))

    resource_tags = Tags(
                        Name=Sub("${AWS::StackName}"),
                        user="josh.dix.labs",
                        stelligent_u_lesson='lesson-4-1',
                        stelligent_u_lab='lab-1'
                    )

    vpc = template.add_resource(
        ec2.VPC(
            "Vpc",
            CidrBlock=Ref(vpc_cidr_param),
            EnableDnsSupport=True,
            EnableDnsHostnames=True,
            InstanceTenancy="default",
            Tags=resource_tags,
        )
    )

    subnet = template.add_resource(
        ec2.Subnet(
            "Subnet",
            VpcId=Ref(vpc),
            CidrBlock=Ref(subnet_cidr_param),
            MapPublicIpOnLaunch=False,
            AvailabilityZone=Select(0, GetAZs()),
            Tags=resource_tags,
        )
    )

    template.add_output([
        Output(
            "vpcId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(vpc),
        ),
        Output(
            "SubnetId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(subnet),
        ),
    ])

    with open(cfn_file, 'w') as f:
        f.write(template.to_yaml())

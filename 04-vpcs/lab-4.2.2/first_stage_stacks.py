import os
# prevents bools showing up as strings
os.environ['TROPO_REAL_BOOL']='true'

from troposphere import Export, GetAtt, Ref, Template, Tags, Sub, Select, GetAZs, Parameter, Output, ImportValue
import troposphere.ec2 as ec2

resource_tags=Tags(
                    Name=Sub("${AWS::StackName}"),
                    user="josh.dix.labs",
                    stelligent_u_lesson='lesson-4-2',
                    stelligent_u_lab='lab-1'
                )

################################################################################
################################################################################
################################################################################
################################################################################

def east_vpc_stack(cfn_file):

    template=Template()

    vpc_cidr_param=template.add_parameter(Parameter(
        "vpcCidrParam",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    subnet_cidr_param=template.add_parameter(Parameter(
        "subnetCidrParam",
        Description="string of subnet cidr block to use",
        Type="String",
    ))

    west_peer_cidr_param=template.add_parameter(Parameter(
        "westPeerCidrParam",
        Type="String",
    ))

    igw=template.add_resource(
        ec2.InternetGateway(
            "Igw",
            Tags=resource_tags,
        )
    )

    vpc=template.add_resource(
        ec2.VPC(
            "Vpc",
            CidrBlock=Ref(vpc_cidr_param),
            EnableDnsSupport=True,
            EnableDnsHostnames=True,
            InstanceTenancy="default",
            Tags=resource_tags,
        )
    )

    igwa=template.add_resource(
        ec2.VPCGatewayAttachment(
            "IgwA",
            VpcId=Ref(vpc),
            InternetGatewayId=Ref(igw),
        )
    )

    route_tbl=template.add_resource(
        ec2.RouteTable(
            "RouteTable",
            VpcId=Ref(vpc),
            Tags=resource_tags,
        )
    )

    default_route=template.add_resource(
        ec2.Route(
            "defaultRoute",
            DestinationCidrBlock="0.0.0.0/0",
            GatewayId=Ref(igw),
            RouteTableId=Ref(route_tbl)
        )
    )

# delete me and update to remove peering stack
    peer_route=template.add_resource(
        ec2.Route(
            "peerRoute",
            DestinationCidrBlock=Ref(west_peer_cidr_param),
            VpcPeeringConnectionId="pcx-0d27f0252e6c8ac93",
            RouteTableId=Ref(route_tbl)
        )
    )

    subnet=template.add_resource(
        ec2.Subnet(
            "Subnet",
            VpcId=Ref(vpc),
            CidrBlock=Ref(subnet_cidr_param),
            MapPublicIpOnLaunch=True,
            AvailabilityZone=Select(0, GetAZs()),
            Tags=resource_tags,
        )
    )

    route_tbl_asoc=template.add_resource(
        ec2.SubnetRouteTableAssociation(
            "RouteTblSubnetAsoc",
            RouteTableId=Ref(route_tbl),
            SubnetId=Ref(subnet)
        )
    )

    my_net_acl = template.add_resource(
        ec2.NetworkAcl(
            "MyFirstNetAcl",
            Tags=resource_tags,
            VpcId=Ref(vpc),
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyAllOutNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=-1,
            Egress=True,
            RuleAction="allow",
            RuleNumber=100,
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyInNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock="74.77.86.69/32",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=100,
            PortRange=ec2.PortRange(From=22, To=22)
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyPriv2PubNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock=Ref(west_peer_cidr_param),
            Protocol=-1,
            RuleAction="allow",
            RuleNumber=101
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyClientPortsNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=102,
            PortRange=ec2.PortRange(From=1024, To=65535)
        )
    )

    template.add_resource(
        ec2.SubnetNetworkAclAssociation(
            "subNaclAsoc",
            NetworkAclId=Ref(my_net_acl),
            SubnetId=Ref(subnet)
        )
    )

    template.add_output([
        Output(
            "VpcId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(vpc),
            Export=Export("VpcId-jdix"),
        ),
        Output(
            "SubnetId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(subnet),
            Export=Export("SubnetId-jdix"),
        ),
    ])
    template_out_yaml(cfn_file, template)

################################################################################
################################################################################
################################################################################
################################################################################

def east_instance_stack(cfn_file):

    template=Template()

    key_name_param=template.add_parameter(Parameter(
        "keyName",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    ami_id_param=template.add_parameter(Parameter(
        "amiId",
        Description="string of vpc cidr block to use",
        Type="AWS::EC2::Image::Id"
    ))

    instance_type_param=template.add_parameter(Parameter(
        "instanceType",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    sg = template.add_resource(
        ec2.SecurityGroup(
            "MySg",
            GroupDescription="who cares",
            VpcId=ImportValue("VpcId-jdix"),
            Tags=resource_tags,
        )
    )

    sshIn = template.add_resource(
        ec2.SecurityGroupIngress(
            "MySshIn",
            CidrIp="0.0.0.0/0",
            IpProtocol="tcp",
            FromPort=22,
            ToPort=22,
            GroupId=Ref(sg)
        )
    )

    pingIn = template.add_resource(
        ec2.SecurityGroupIngress(
            "MyPingIn",
            CidrIp="0.0.0.0/0",
            IpProtocol="icmp",
            FromPort=-1,
            ToPort=-1,
            GroupId=Ref(sg)
        )
    )

    instance = template.add_resource(
        ec2.Instance(
            "MyInstance",
            ImageId=Ref(ami_id_param),
            SubnetId=ImportValue("SubnetId-jdix"),
            InstanceType=Ref(instance_type_param),
            KeyName=Ref(key_name_param),
            Tags=resource_tags,
            SecurityGroupIds=[Ref(sg)],
        )
    )

    instance_elastic_ip = template.add_resource(
        ec2.EIP(
            "MyEip",
            InstanceId=Ref(instance),
            Tags=resource_tags,
        )
    )

    template.add_output([
        Output(
            "InstanceId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(instance),
            Export=Export("InstanceId-jdix"),
        ),
        Output(
            "InstancePrivateIP",
            Description="InstanceId of the newly created EC2 instance",
            Value=GetAtt(instance, "PrivateIp"),
            Export=Export("InstancePrivateIP-jdix"),
        )
    ])
    template_out_yaml(cfn_file, template)

################################################################################
################################################################################
################################################################################
################################################################################

def west_vpc_stack(cfn_file):

    template=Template()

    vpc_cidr_param=template.add_parameter(Parameter(
        "vpcCidrParam",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    subnet_cidr_param=template.add_parameter(Parameter(
        "subnetCidrParam",
        Description="string of subnet cidr block to use",
        Type="String",
    ))

    east_peer_cidr_param=template.add_parameter(Parameter(
        "eastPeerCidrParam",
        Type="String",
    ))

    vpc=template.add_resource(
        ec2.VPC(
            "Vpc",
            CidrBlock=Ref(vpc_cidr_param),
            EnableDnsSupport=True,
            EnableDnsHostnames=True,
            InstanceTenancy="default",
            Tags=resource_tags,
        )
    )

    route_tbl=template.add_resource(
        ec2.RouteTable(
            "RouteTable",
            VpcId=Ref(vpc),
            Tags=resource_tags,
        )
    )

    subnet=template.add_resource(
        ec2.Subnet(
            "Subnet",
            VpcId=Ref(vpc),
            CidrBlock=Ref(subnet_cidr_param),
            MapPublicIpOnLaunch=True,
            AvailabilityZone=Select(0, GetAZs()),
            Tags=resource_tags,
        )
    )

    route_tbl_asoc=template.add_resource(
        ec2.SubnetRouteTableAssociation(
            "RouteTblSubnetAsoc",
            RouteTableId=Ref(route_tbl),
            SubnetId=Ref(subnet)
        )
    )

# delete me and update to remove peering stack
    peer_route=template.add_resource(
        ec2.Route(
            "peerRoute",
            DestinationCidrBlock=Ref(east_peer_cidr_param),
            VpcPeeringConnectionId="pcx-0d27f0252e6c8ac93",
            RouteTableId=Ref(route_tbl)
        )
    )


    my_net_acl = template.add_resource(
        ec2.NetworkAcl(
            "MyFirstNetAcl",
            Tags=resource_tags,
            VpcId=Ref(vpc),
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyAllOutNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=-1,
            Egress=True,
            RuleAction="allow",
            RuleNumber=100,
        )
    )

    template.add_resource(
        ec2.NetworkAclEntry(
            "MyPriv2PubNetAclEntry",
            NetworkAclId=Ref(my_net_acl),
            CidrBlock=Ref(east_peer_cidr_param),
            Protocol=-1,
            RuleAction="allow",
            RuleNumber=101
        )
    )

    template.add_resource(
        ec2.SubnetNetworkAclAssociation(
            "subNaclAsoc",
            NetworkAclId=Ref(my_net_acl),
            SubnetId=Ref(subnet)
        )
    )

    template.add_output([
        Output(
            "VpcId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(vpc),
            Export=Export("VpcId-jdix"),
        ),
        Output(
            "SubnetId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(subnet),
            Export=Export("SubnetId-jdix"),
        ),
    ])
    template_out_yaml(cfn_file, template)

################################################################################
################################################################################
################################################################################
################################################################################

def west_instance_stack(cfn_file):

    template=Template()

    key_name_param=template.add_parameter(Parameter(
        "keyName",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    ami_id_param=template.add_parameter(Parameter(
        "amiId",
        Description="string of vpc cidr block to use",
        Type="AWS::EC2::Image::Id"
    ))

    instance_type_param=template.add_parameter(Parameter(
        "instanceType",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    sg = template.add_resource(
        ec2.SecurityGroup(
            "MySg",
            GroupDescription="who cares",
            VpcId=ImportValue("VpcId-jdix"),
            Tags=resource_tags,
        )
    )

    sshIn = template.add_resource(
        ec2.SecurityGroupIngress(
            "MySshIn",
            CidrIp="0.0.0.0/0",
            IpProtocol="tcp",
            FromPort=22,
            ToPort=22,
            GroupId=Ref(sg)
        )
    )

    pingIn = template.add_resource(
        ec2.SecurityGroupIngress(
            "MyPingIn",
            CidrIp="0.0.0.0/0",
            IpProtocol="icmp",
            FromPort=-1,
            ToPort=-1,
            GroupId=Ref(sg)
        )
    )

    instance = template.add_resource(
        ec2.Instance(
            "MyInstance",
            ImageId=Ref(ami_id_param),
            SubnetId=ImportValue("SubnetId-jdix"),
            InstanceType=Ref(instance_type_param),
            KeyName=Ref(key_name_param),
            Tags=resource_tags,
            SecurityGroupIds=[Ref(sg)],
        )
    )

    template.add_output([
        Output(
            "InstanceId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(instance),
            Export=Export("InstanceId-jdix"),
        ),
        Output(
            "InstancePrivateIP",
            Description="InstanceId of the newly created EC2 instance",
            Value=GetAtt(instance, "PrivateIp"),
            Export=Export("InstancePrivateIP-jdix"),
        )
    ])
    template_out_yaml(cfn_file, template)


################################################################################
################################################################################
################################################################################
################################################################################

def template_out_yaml(cfn_file, template):
    with open(cfn_file, 'w') as f:
        f.write(template.to_yaml())
import os
# prevents bools showing up as strings
os.environ['TROPO_REAL_BOOL']='true'

from troposphere import Export, GetAtt, Ref, Template, Tags, Sub, Select, GetAZs, Parameter, Output, ImportValue
import troposphere.ec2 as ec2

resource_tags=Tags(
                    Name=Sub("${AWS::StackName}"),
                    user="josh.dix.labs",
                    stelligent_u_lesson='lesson-4-1',
                    stelligent_u_lab='lab-1'
                )

# "vpc stack"
def dump_base_yaml(cfn_file):

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

    priv_route_tbl=template.add_resource(
        ec2.RouteTable(
            "PrivRouteTable",
            VpcId=Ref(vpc),
            Tags=resource_tags,
        )
    )

    priv_subnet=template.add_resource(
        ec2.Subnet(
            "PrivSubnet",
            VpcId=Ref(vpc),
            CidrBlock="10.10.1.0/24",
            MapPublicIpOnLaunch=False,
            AvailabilityZone=Select(0, GetAZs()),
            Tags=resource_tags,
        )
    )

    route_tbl_asoc=template.add_resource(
        ec2.SubnetRouteTableAssociation(
            "RouteTblPrivSubnetAsoc",
            RouteTableId=Ref(priv_route_tbl),
            SubnetId=Ref(priv_subnet)
        )
    )

    ngw_elastic_ip = template.add_resource(
        ec2.EIP(
            "MyNgwEip",
            Tags=resource_tags,
        )
    )

    nat_gateway = template.add_resource(
        ec2.NatGateway(
            "MyNatGateway",
            AllocationId=GetAtt(ngw_elastic_ip, "AllocationId"),
            SubnetId=Ref(subnet),
        )
    )

    private_out_route=template.add_resource(
        ec2.Route(
            "privateOutRoute",
            DestinationCidrBlock="0.0.0.0/0",
            NatGatewayId=Ref(nat_gateway),
            RouteTableId=Ref(priv_route_tbl)
        )
    )

    first_network_acl = template.add_resource(
        ec2.NetworkAcl(
            "MyFirstNetAcl",
            Tags=resource_tags,
            VpcId=Ref(vpc),
        )
    )

    network_out_second_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPrivOutNetAclEntry",
            NetworkAclId=Ref(first_network_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=-1,
            Egress=True,
            RuleAction="allow",
            RuleNumber=100,
        )
    )

    network_inbound_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyInNetAclEntry",
            NetworkAclId=Ref(first_network_acl),
            CidrBlock="74.77.86.69/32",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=100,
            PortRange=ec2.PortRange(From=22, To=22)
        )
    )

    private_to_public_client_ports_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPriv2PubClientPortsNetAclEntry",
            NetworkAclId=Ref(first_network_acl),
            CidrBlock="10.10.1.0/24",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=101,
            PortRange=ec2.PortRange(From=1024, To=65535)
        )
    )

    public_to_internet_client_ports_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPub2DefaultClientPortsNetAclEntry",
            NetworkAclId=Ref(first_network_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=102,
            PortRange=ec2.PortRange(From=1024, To=65535)
        )
    )

    public_to_private_icmpv4_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPubIcmpv4NetAclEntry",
            NetworkAclId=Ref(first_network_acl),
            CidrBlock="10.10.1.0/24",
            Protocol=1,
            Icmp=ec2.ICMP(Code=-1, Type=-1),
            RuleAction="allow",
            RuleNumber=103
        )
    )

    second_network_acl = template.add_resource(
        ec2.NetworkAcl(
            "MySecondNetAcl",
            Tags=resource_tags,
            VpcId=Ref(vpc),
        )
    )

    network_out_second_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPriv2InternetClientPortsNetAclEntry",
            NetworkAclId=Ref(second_network_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=100,
            PortRange=ec2.PortRange(From=1024, To=65535)
        )
    )

    public_to_private_ssh_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPrivSshNetAclEntry",
            NetworkAclId=Ref(second_network_acl),
            CidrBlock="10.10.0.0/24",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=101,
            PortRange=ec2.PortRange(From=22, To=22)
        )
    )

    public_to_private_http_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPrivHttpNetAclEntry",
            NetworkAclId=Ref(second_network_acl),
            CidrBlock="10.10.0.0/24",
            Protocol=6,
            RuleAction="allow",
            RuleNumber=102,
            PortRange=ec2.PortRange(From=80, To=80)
        )
    )

    private_to_public_icmpv4_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPrivIcmpv4NetAclEntry",
            NetworkAclId=Ref(second_network_acl),
            CidrBlock="10.10.0.0/24",
            Protocol=1,
            Icmp=ec2.ICMP(Code=-1, Type=-1),
            RuleAction="allow",
            RuleNumber=103
        )
    )

    network_out_second_acl_entry = template.add_resource(
        ec2.NetworkAclEntry(
            "MyPubOutNetAclEntry",
            NetworkAclId=Ref(second_network_acl),
            CidrBlock="0.0.0.0/0",
            Protocol=-1,
            Egress=True,
            RuleAction="allow",
            RuleNumber=100,
        )
    )

    subnet_nacl_asociation = template.add_resource(
        ec2.SubnetNetworkAclAssociation(
            "subNaclAsoc",
            NetworkAclId=Ref(first_network_acl),
            SubnetId=Ref(subnet)
        )
    )

    priv_subnet_nacl_asociation = template.add_resource(
        ec2.SubnetNetworkAclAssociation(
            "privSubNaclAsoc",
            NetworkAclId=Ref(second_network_acl),
            SubnetId=Ref(priv_subnet)
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
        Output(
            "PrivSubnetId",
            Description="InstanceId of the newly created EC2 instance",
            Value=Ref(priv_subnet),
            Export=Export("PrivSubnetId-jdix"),
        ),
    ])
    template_out_yaml(cfn_file, template)

# "instance stack"
def dump_lab_yaml(cfn_file):

    template=Template()

    key_name_param=template.add_parameter(Parameter(
        "keyName",
        Description="string of vpc cidr block to use",
        Type="String",
    ))

    ami_id_param=template.add_parameter(Parameter(
        "AmiId",
        Description="string of vpc cidr block to use",
        Type="AWS::EC2::Image::Id"
    ))

    instance_type_param=template.add_parameter(Parameter(
        "InstanceType",
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

    priv_instance = template.add_resource(
        ec2.Instance(
            "MyPrivInstance",
            ImageId=Ref(ami_id_param),
            SubnetId=ImportValue("PrivSubnetId-jdix"),
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

def template_out_yaml(cfn_file, template):
    with open(cfn_file, 'w') as f:
        f.write(template.to_yaml())
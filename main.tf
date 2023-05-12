#download aws provider
provider "aws" {

region="us-east-1"

}

#create vpc called dev-vpc with network ip 10.0.0.0/16
resource "aws_vpc" "app-vpc"{
    cidr_block = var.vpc-cidr
    tags={ 
        Name: "${var.env-prefix}-vpc"
    }
}


#create subnet inside dev-vpc called dev-subnet with network ip 10.0.10.0/24
resource "aws_subnet" "app-sub"{
   vpc_id = aws_vpc.app-vpc.id
   cidr_block =var.sub-cidr
   availability_zone =var.avail_zone
   tags={
        Name : "${var.env-prefix}-subnet"
    }
}

#create route table in dev-vpc called dev-igw with default route 0.0.0.0/0
 resource "aws_route_table" "app-rt"{
    vpc_id = aws_vpc.app-vpc.id

    route{
        cidr_block = var.default_route
        gateway_id=aws_internet_gateway.app-igw.id
    }
      tags={
        Name="${var.env-prefix}-igw"
      }
    
     }
# create internet gateway called app-igw inside dev-vpc to allow pulic access
 resource "aws_internet_gateway" "app-igw"{
    vpc_id = aws_vpc.app-vpc.id

 }
#accociate subnet with route table to add default route and local route to subnet rote table
 resource "aws_route_table_association" "rt-ass"{
    subnet_id = aws_subnet.app-sub.id
    route_table_id = aws_route_table.app-rt.id

 }
#create securiy group called app-sg wich include inbound and outbound traffic rules 
 resource "aws_security_group" "app-sg"{
    name = "app-sg"
    vpc_id = aws_vpc.app-vpc.id
    ingress {
        from_port = 22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port=8080
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags={
        Name:"${var.env-prefix}-sg"
    }
 }
#fetch amazon linux image with automated way to get last version 
 data "aws_ami" "latest-amazon-linux-image"{
    most_recent=true
    owners=["amazon"]
    filter{
       name="name"
       values=["amzn2-ami-kernel-*-x86_64-gp2"]
    }
 }
#create ec2 instance in pecific availablity zone inside dev-sub , using ami last version , assign app-sg to ec2 and use user data to boot script  
 resource "aws_instance" "app-ec2"{
    ami=data.aws_ami.latest-amazon-linux-image.id
    instance_type=var.instance_type
    subnet_id = aws_subnet.app-sub.id
    vpc_security_group_ids = [aws_security_group.app-sg.id]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ec2-key.key_name
    user_data = file("script.sh")
    tags={
        Name:"${var.env-prefix}-ec2"
    }
 }
#create key pair called ec2-key to allow ssh to ec2
 resource "aws_key_pair" "ec2-key" {
    key_name = "ec2-key"
    public_key = file(var.key-location)
 }


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
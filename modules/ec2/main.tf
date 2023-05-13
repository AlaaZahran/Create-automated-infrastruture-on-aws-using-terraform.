
#create securiy group called app-sg wich include inbound and outbound traffic rules 
 resource "aws_security_group" "app-sg"{
    name = "app-sg"
    vpc_id = var.vpc_id
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
       values=[var.image-name]
    }
 }
#create ec2 instance in pecific availablity zone inside dev-sub , using ami last version , assign app-sg to ec2 and use user data to boot script  
 resource "aws_instance" "app-ec2"{
    ami=data.aws_ami.latest-amazon-linux-image.id
    instance_type=var.instance_type
    subnet_id = var.subnet-id
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
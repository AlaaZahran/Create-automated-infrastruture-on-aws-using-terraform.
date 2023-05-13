module "app-network" {
    source = "./modules/network"
    avail_zone=var.avail_zone
    vpc-cidr=var.vpc-cidr
    sub-cidr=var.sub-cidr
    env-prefix=var.env-prefix
    default_route=var.default_route
    }

module "app-ec2"{
    source ="./modules/ec2"
    vpc_id=module.app-network.vpc.id
    env-prefix=var.env-prefix
    image-name=var.image-name
    instance_type=var.instance_type
    subnet-id=module.app-network.subnet.id
    avail_zone=var.avail_zone
    key-location=var.key-location

}

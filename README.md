
# Project Title

Create automated infrastruture on aws using terraform.



## Description
This project aims to create an ec2 instance  to run nginx container inside it ,this ece created in a public subnet in new vpc in specific availablity zone  and attach a security group it  to allow ssh and http.

## Components

1- aws vpc      

2- aws subnet 

3- aws internet geteway

4- route table

5- security group

6- key pair 
 
7- aws ec2



## Steps

1- Create vpc called dev-vpc with network ip 10.0.0.0/16.

2- Create subnet inside dev-vpc called dev-subnet with network ip 10.0.10.0/24.

3-  Create internet gateway called app-igw inside dev-vpc to allow pulic access.

4- Create route table in dev-vpc called dev-igw with default route 0.0.0.0/0.

5- Accociate subnet with route table to add default route and local route to subnet rote table.

6- Create securiy group called app-sg wich include inbound and outbound traffic rules 

 - inbound rules :
     
     - allow ssh on port 22

     - allow http on port 8080

  - outbound rules:
    
     - allow all outbound rules
7- Fetch amazon linux image with automated way to get last version 

8- Create key pair called ec2-key to allow ssh to ec2

9- Create ec2 instance with specific parmaters:
 - using last version of linux ami
 - in pecific availablity zone 
 - inside dev-vpc
 - in dev-sub
 - with app-sg
 - with public ip address
 - with key pair ec2-key

 this ec2 used to run nginx container by using user data script to run required configuration.
 



## Deployment

To deploy this project run:

* To download aws provider and project dependencies

```bash
  terraform init

```
* To check and test project before apply (dry run)
```bash
  terraform plan
```  
* finally To apply project 
```bash
  terraform applay
```

## Project Diagram

![image](https://github.com/AlaaZahran/2-Tier-App-using--terraform/assets/46306526/01fb2d58-67db-4f90-a70d-774b9a7e048a)

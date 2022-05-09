# Terraform module for CMDBuild

## Overview

This code provisions all the components that are required to quickly run CMDB in an EC2 Instance.

Tools and versions required to run the code:
- **packer=>1.7.5**: Create the AMIs
- **terraform=>1.0.1**: Create the ec2 instance with eip
- **aws=>3.53.0**: Cloud provider where infrastructure exists.

## Usage

### Required parameters
The *Subnet ID* is the only parameter required to run this automation.
It can be obtained from the AWS Web Console -> VPC -> Subnets

Once gotten is recommened to set it up using the following command
`export TF_VAR_subnet_id=<your-subnet-id>`

Setup your local AWS Profile.
`export AWS_ACCESS_KEY_ID=<your-aws-access-key-id>`
`export AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>`

### Default configuration
The implementation will make use of the following configuration:
- `us-east-1` region
- `t2.medium`instance size
- 8080 port for the CMDBuild Service

### Build Amazon Machine Image (AMI)

```
cd packer
packer build -var subnet_id=<your-subnet-id> cmdbuild.pkr.hcl
```

In the AWS Console a new AMI Image named cmdbuild in the us-east-1 region should now be shown.

### Deploy resources

#### Variables:
##### Required
- **subnet-id**: Subnet to launch the resources in

#### Run terraform
```
terraform apply
```
#### Output
- **cmdbuild_public_ip**: CMDBuild server public IP
- **private_key_id**: Ec2-Key that can be used to login into the instance

#### CMDBuild access
In your browser access the follwing address:
http://<public-ip-address>:8080/cmdbuild

##### Setup CMDBuild
To make use of CMDBuild in this installation enter the following params:
- *Type:* Demo
- *Name:* testdb
- *Username:* admin
- *Password:* admin
- *Admin username:* postgres
- *Admin password:* postgres

Click on Test connection, a success message should pop up.
Click on Configure.

To access CMDB enter admin admin credentials.

### SSH Access
To login execute the following command replacing accordingly:
`ssh -i artifacts/private.pem ubuntu@<public-ip-address>`

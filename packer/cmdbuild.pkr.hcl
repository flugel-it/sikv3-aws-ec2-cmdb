variable "ami_name" {
  description = "The Amazon Machine Image that will be used for provisioning CMDBuild"
  type        = string
  default     = "cmdbuild"
}

variable "subnet_id" {
    description = "The subnet id where the image will work i.e. subnet-0c3b7c3488903ebb8"
    type        = string
}

// AMI Builder (EBS backed)
// https://www.packer.io/docs/builders/amazon/ebs
source "amazon-ebs" "cmdb" {
  ami_name      = var.ami_name
  source_ami    = "ami-005de95e8ff495156"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  ssh_username  = "ubuntu"
  region        = "us-east-1"
}

build {
  sources = ["source.amazon-ebs.cmdb"]

  provisioner "file" {
    destination = "/tmp/"
    source      = "./tomcat-users.xml"
  }

  provisioner "shell" {
    script = "./bootstrapper.sh"
  }
}
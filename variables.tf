variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "Key name for the instance"
  type        = string
  default     = "EC2-key"
}

variable "associate_public_ip_address" {
  description = "Associate public ip"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^true$|^false$|^$", var.associate_public_ip_address))
    error_message = "The associate_public_ip_address value must be a boolean."
  }
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

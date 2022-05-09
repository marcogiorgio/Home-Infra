variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "az_list" {
  default = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f"
  ]
}

variable "profile" {
  description = "Profile"
  type        = string
  default     = "default"
}

variable "VPC" {
  description = "Main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_block" {
  description = "Public subnet, internet access through NAT Gateway"
  type        = string
  default     = "10.0.1.0/24"
}

variable "internet_subnet_block" {
  description = "Internet subnet, direct internet access through Internet gateway"
  default     = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "private_subnet_block" {
  description = "Private subnet, no internet access"
  default     = ["10.0.200.0/24", "10.0.201.0/24"]
}

variable "home_ip" {
  description = "Home IP used to allow connection to bastion host"
  type        = string
  default     = "My IP/32"
}

variable "server_instances" {
  description = "Number of EC2 server instances"
  type        = number
  default     = 2
}
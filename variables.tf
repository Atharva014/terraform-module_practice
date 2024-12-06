variable "aws_region" {
  default = "ap-south-1"
  type = string
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "web_pub_sub_cidr" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "app_priv_sub_cidr" {
  type = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "db_priv_sub_cidr" {
  type = list(string)
  default = [ "10.0.5.0/24", "10.0.6.0/24" ]
}

variable "pub_sub_az" {
  type = list(string)
  default = [ "ap-south-1a", "ap-south-1b" ]
}

variable "priv_sub_az" {
  type = list(string)
  default = [ "ap-south-1a", "ap-south-1b" ]
}

variable "vpc_ami" {
  type = string
  default = "ami-0614680123427b75e"
}

variable "key_pair" {
  type = string
  default = "linux-key"
}

variable "root_volume_size" {
  type = number
  default = 10
}
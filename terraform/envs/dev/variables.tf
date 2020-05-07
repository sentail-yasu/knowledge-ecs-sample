variable "vpc_cidr"{
  default = "10.1.0.0/16"
}

variable "subnet_cidr" {
  type = "map"

  default = {
    public-a  = "10.1.10.0/24"
    public-c  = "10.1.20.0/24"
    private-a = "10.1.100.0/24"
    private-c = "10.1.200.0/24"
  }
}

variable "name" {
  default = "knowledge"
}

variable "rds_instance_class" {
  default = "db.t2.small"
}
variable "database_name" {
  default = "knowledge"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {}

variable "region" {
  default = "ap-northeast-1"
}

variable "ami_id" {
  default = "ami-0f310fced6141e627"　←AmazonLinux2 x86-64
}

variable "instance_count" {
  default = 2
}

variable "public_subnets" {
  default = {
    "0" = "subnet-xxxx"　←一回実行してサブネット作成後に手動で入れてください
    "1" = "subnet-xxxx"　←一回実行してサブネット作成後に手動で入れてください
  }
}
variable "private_subnets" {
  default = {
    "0" = "subnet-xxxx"　←一回実行してサブネット作成後に手動で入れてください
    "1" = "subnet-xxxx"　←一回実行してサブネット作成後に手動で入れてください
  }
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair" {
  default = "your key pair"
}

variable "app_name" {
  default = "web"
}

variable "bastion_name" {
  default = "bastion"
}

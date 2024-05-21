create_vpc = false
vpc_cidr   = "10.0.0.0/16"

// if you don't want to create a new VPC, provide the vpc_id and subnet_ids and set create_vpc to false
vpc_id                      = "vpc-39b8da44"
subnets                     = ["subnet-5817463e", "subnet-f191cdd0"]
rke2_version                = "v1.25.12+rke2r1"
cluster_name                = "juned-rke2"
associate_public_ip_address = true
servers                     = 1
// nodepool_asg                = { min : 1, desired : 1, max : 3 }
block_device_mappings       = { size : 50, type : "gp2" }
tags                        = { "Environment" : "prod" }
enable_nat_gateway          = true
single_nat_gateway          = true
instance_types              = ["t3.large"]
// if you want to setup a mirror for https://registry1.dso.mil container registry, set the following variables
create_registry1_mirror        = false
registry1_mirror_proxy_address = "http://44.210.192.97:5000"
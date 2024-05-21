inputs = {
  create_vpc         = false
  vpc_cidr           = "10.0.0.0/16"
  enable_nat_gateway = true
  single_nat_gateway = true

  // if you don't want to create a new VPC, set create_vpc to false and provide the vpc_id and subnet_ids and 
  vpc_id  = "vpc-39b8da44"
  subnets = ["subnet-5817463e", "subnet-f191cdd0"]

  cluster_name                = "juned-rke2"
  instance_type               = "t3.large"
  associate_public_ip_address = true
  servers                     = 1
  asg                         = { min = 1, max = 10, desired = 1, suspended_processes = [], termination_policies = ["Default"] }
  block_device_mappings       = { size : 50, type : "gp2" }
  tags                        = { Environment : "prod" }

  // if you want to setup a mirror for https://registry1.dso.mil container registry, set the following variables
  create_registry1_mirror        = false
  registry1_mirror_proxy_address = "http://44.210.192.97:5000"

}

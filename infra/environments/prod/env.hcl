inputs = {
  create_vpc         = true
  vpc_cidr           = "10.0.0.0/16"
  enable_nat_gateway = true
  single_nat_gateway = true

  // Optional existing-network mode:
  // create_vpc = false
  // vpc_id  = "vpc-xxxxxxxx"
  // subnets = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]

  rke2_version                = "v1.34.5+rke2r1" // official stable channel as of 2026-03-13
  instance_type               = "t3.large"
  associate_public_ip_address = true
  controlplane_internal       = false
  servers                     = 1
  asg                         = { min = 1, max = 10, desired = 1, suspended_processes = [], termination_policies = ["Default"] }
  block_device_mappings       = { size = 50, type = "gp2" }

  // if you want to setup a mirror for https://registry1.dso.mil container registry, set the following variables
  create_registry1_mirror        = true
  registry1_mirror_proxy_address = "http://44.210.192.97:5000"

}

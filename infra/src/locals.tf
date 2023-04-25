data "aws_ami" "rhel8" {
  most_recent = true
  # owners      = ["309956199498"]
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["RHEL-8.7*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  # filter {
  #   name   = "tag:Environment"
  #   values = ["dev"]
  # }
}
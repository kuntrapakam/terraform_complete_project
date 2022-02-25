locals {
  subnet_names = module.vpc.public_subnets
}
module "ec2-instance-new" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"

  depends_on = [
    module.vpc
  ]
  name = "${local.name}-new-private-instance"

  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t2.micro"
  key_name      = "newkey"
  //monitoring             = true
  user_data              = file("nginx.sh")
  vpc_security_group_ids = [module.security-group.security_group_id]
  # for_each = {for index, subnet in local.subnet_names : index => subnet}
  # subnet_id              = local.subnet_names[each.key]
  subnet_id = module.vpc.public_subnets[0]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
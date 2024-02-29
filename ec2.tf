resource "aws_instance" "dev" {
  ami           = var.ec2-ami
  instance_type = var.ec2-instance-type
  key_name      = var.ec2-key-name

  tags = var.tags

  vpc_security_group_ids      = [module.security.sg-web.id]
  associate_public_ip_address = true
  subnet_id                   = module.network.public_subnets[0].id

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}
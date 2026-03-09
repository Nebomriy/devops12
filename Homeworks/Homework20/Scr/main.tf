module "nginx_ec2" {
  source = "./modules/nginx_ec2"

  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  list_of_open_ports = var.list_of_open_ports
  instance_type      = var.instance_type
}
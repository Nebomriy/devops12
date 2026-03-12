output "instance_public_ips" {
  value = [for instance in aws_instance.web : instance.public_ip]
}

output "inventory_file" {
  value = local_file.ansible_inventory.filename
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}
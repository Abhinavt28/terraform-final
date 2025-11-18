output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_instance_ip" {
  value = module.ec2.public_ip
}

output "nat_gateway_id" {
  value = module.nat.nat_id
}

output "vpc_peering_id" {
  value = module.peering.peering_id
}

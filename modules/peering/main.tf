resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = var.custom_vpc_id
  peer_vpc_id = var.default_vpc_id
  auto_accept = true
  tags = { Name = "CustomVPC-to-DefaultVPC" }
}

# Add default VPC routes to reach custom VPC
data "aws_route_tables" "default_rt" {
  vpc_id = var.default_vpc_id
}

resource "aws_route" "default_to_custom" {
  for_each = toset(data.aws_route_tables.default_rt.ids)
  route_table_id            = each.key
  destination_cidr_block    = var.custom_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Add custom VPC routes to reach default VPC
resource "aws_route" "custom_to_default_public" {
  route_table_id            = var.public_rt_id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "custom_to_default_private" {
  route_table_id            = var.private_rt_id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

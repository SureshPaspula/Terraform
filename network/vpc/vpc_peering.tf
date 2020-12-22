# Establish peering connection with admin VPC, if necessary
resource "aws_vpc_peering_connection" "main" {
  count = local.enable_vpc_peering ? 1 : 0

  vpc_id      = var.admin_vpc_id
  peer_vpc_id = module.vpc.vpc_id

  auto_accept = true

  tags = merge(var.tags, {
    Name = "${var.prefix}"
  })
}

# Add route to direct traffic to client VPC from private subnets in admin VPC
resource "aws_route" "admin_private_to_client" {
  count = local.enable_vpc_peering ? 1 : 0

  route_table_id            = var.admin_private_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[0].id
}

# Add route to direct traffic to client VPC from public subnets in admin VPC
resource "aws_route" "admin_public_to_client" {
  count = local.enable_vpc_peering ? 1 : 0

  route_table_id            = var.admin_public_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[0].id
}

# Add route to direct traffic to admin VPC from client private subnets
resource "aws_route" "client_private_to_admin" {
  count = local.enable_vpc_peering ? 1 : 0

  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = var.admin_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[0].id
}

# Add route to direct traffic to admin VPC from client public subnets
resource "aws_route" "client_public_to_admin" {
  count = local.enable_vpc_peering ? 1 : 0

  route_table_id            = module.vpc.public_route_table_ids[0]
  destination_cidr_block    = var.admin_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[0].id
}

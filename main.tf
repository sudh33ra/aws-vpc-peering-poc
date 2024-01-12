data "aws_caller_identity" "peer" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.main_vpc_id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = var.account_id
  peer_region   = var.peer_vpc_region 
  auto_accept   = false

  # TODO : get automatic DNS resolution working
  #  accepter {
  #    allow_remote_vpc_dns_resolution = true
  #  }
  #
  #  requester {
  #    allow_remote_vpc_dns_resolution = true
  #  }  

  tags = {
    Side = "Requester"
    Name = "VPC Peering between ${var.main_vpc_region} and ${var.peer_vpc_region}"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

# Create peering route for main
resource "aws_route" "main_r" {
  count                     = length(var.main_pub_sn_rtid)
  route_table_id            = var.main_pub_sn_rtid[count.index]
  destination_cidr_block    = var.peer_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Create peering route for peer
resource "aws_route" "peer_r" {
  provider                  = aws.peer
  count                     = length(var.peer_pub_sn_rtid)
  route_table_id            = var.peer_pub_sn_rtid[count.index]
  destination_cidr_block    = var.main_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

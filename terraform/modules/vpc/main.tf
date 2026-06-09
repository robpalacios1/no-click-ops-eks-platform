# ====================================================================
# 1. Create VPC
# ====================================================================

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.main_vpc_cidr_block
  enable_dns_hostnames = var.main_vpc_enable_dns_hostnames
  enable_dns_support   = var.main_vpc_enable_dns_support

  tags = var.main_vpc_tags
}

# ====================================================================
# 2. Create Internet Gateway
# ====================================================================

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = var.igw_tags
}

# ====================================================================
# 3. Create Public Subnets 
# ====================================================================

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_1_cidr_block
    availability_zone = var.public_subnet_1_availability_zone
    map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch

    tags = var.public_subnet_1_tags
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_2_cidr_block
    availability_zone = var.public_subnet_2_availability_zone
    map_public_ip_on_launch = var.public_subnet_2_map_public_ip_on_launch

    tags = var.public_subnet_2_tags
}

# ====================================================================
# 4. Create Private Subnets
# ====================================================================

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_1_cidr_block
    availability_zone = var.private_subnet_1_availability_zone
    
    tags = var.private_subnet_1_tags
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.private_subnet_2_cidr_block
    availability_zone = var.private_subnet_2_availability_zone
    
    tags = var.private_subnet_2_tags
}

# ====================================================================
# 5. Create Elastic IP's (EIP's) for NAT Gateways
# ====================================================================

resource "aws_eip" "nat_eip_1" {
  domain = "vpc"

  tags = var.nat_eip_1_tags
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"

  tags = var.nat_eip_2_tags    
  depends_on = [aws_internet_gateway.igw]
}

# ====================================================================
# 6. Create NAT Gateways
# ====================================================================

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id = aws_subnet.public_subnet_1.id

  tags = var.nat_gateway_1_tags
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id = aws_subnet.public_subnet_2.id

  tags = var.nat_gateway_2_tags
  depends_on = [aws_internet_gateway.igw]
}

# ====================================================================
# 7. Create route tables
# ====================================================================

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.public_route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.public_route_table_tags
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.private_route_table_1_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  tags = var.private_route_table_1_tags
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.private_route_table_2_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }

  tags = var.private_route_table_2_tags
}

# ====================================================================
# 8. Create route tables associations
# ====================================================================

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}   

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}       

# ====================================================================
# 9. Create security groups
# ====================================================================

resource "aws_security_group" "public_security_group" {
  name        = var.public_security_group_name
  description = var.public_security_group_description
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.public_security_group_ingress
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.public_security_group_egress
    content {
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_security_group" "private_security_group" {
  name        = var.private_security_group_name
  description = var.private_security_group_description
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = var.private_security_group_ingress
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.private_security_group_egress
    content {
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_security_group_rule" "public_egress" {
  type              = var.public_egress_type
  from_port         = var.public_egress_from_port
  to_port           = var.public_egress_to_port
  protocol          = var.public_egress_protocol
  security_group_id = aws_security_group.public_security_group.id
  cidr_blocks       = var.public_egress_cidr_blocks
}

resource "aws_security_group_rule" "private_egress" {
  type              = var.private_egress_type
  from_port         = var.private_egress_to_port
  to_port           = var.private_egress_to_port
  protocol          = var.private_egress_protocol
  security_group_id = aws_security_group.private_security_group.id
  cidr_blocks       = var.private_egress_cidr_blocks
}   
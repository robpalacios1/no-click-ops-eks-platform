# ====================================================================
# 1. VPC Variables  
# ====================================================================

variable "main_vpc_cidr_block" {
    type    = string
    default = "10.0.0.0/16"
}

variable "main_vpc_enable_dns_hostnames" {
    type    = bool
    default = true
}

variable "main_vpc_enable_dns_support" {
    type    = bool
    default = true
}

variable "main_vpc_tags" {
  type = map(string)
  default = {
    Name        = "main-vpc"
    environment = "dev"
  }
}

# ====================================================================
# 2. IGW Variables  
# ====================================================================

variable "igw_tags" {
  type = map(string)
  default = {
    Name        = "igw"
    environment = "dev"
  }
}

# ====================================================================
# 3. Public Subnet Variables  
# ====================================================================

variable "public_subnet_1_cidr_block" {
    type    = string
    default = "10.0.1.0/24"
}

variable "public_subnet_1_availability_zone" {
    type    = string
    default = "us-east-1a"
}

variable "public_subnet_1_map_public_ip_on_launch" {
    type    = bool
    default = true
}

variable "public_subnet_1_tags" {
  type = map(string)
  default = {
    Name        = "public-subnet-1"
    environment = "dev"
    "kubernetes.io/role/elb" = "1"
  }
}

variable "public_subnet_2_cidr_block" {
    type    = string
    default = "10.0.2.0/24"
}

variable "public_subnet_2_availability_zone" {
    type    = string
    default = "us-east-1b"
}

variable "public_subnet_2_map_public_ip_on_launch" {
    type    = bool
    default = true
}

variable "public_subnet_2_tags" {
  type = map(string)
  default = {
    Name        = "public-subnet-2"
    environment = "dev"
    "kubernetes.io/role/elb" = "1"
  }
}

# ====================================================================
# 4. Private Subnet Variables  
# ====================================================================

variable "private_subnet_1_cidr_block" {
    type    = string
    default = "10.0.3.0/24"
}

variable "private_subnet_1_availability_zone" {
    type    = string
    default = "us-east-1a"
}

variable "private_subnet_1_tags" {
  type = map(string)
  default = {
    Name        = "private-subnet-1"
    environment = "dev"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

variable "private_subnet_2_cidr_block" {
    type    = string
    default = "10.0.4.0/24"
}

variable "private_subnet_2_availability_zone" {
    type    = string
    default = "us-east-1b"
}

variable "private_subnet_2_tags" {
  type = map(string)
  default = {
    Name        = "private-subnet-2"
    environment = "dev"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ====================================================================
# 5. NAT Gateway Variables  
# ====================================================================

variable "nat_eip_1_tags" {
  type = map(string)
  default = {
    Name        = "nat-eip-1"
    environment = "dev"
  }
}

variable "nat_eip_2_tags" {
  type = map(string)
  default = {
    Name        = "nat-eip-2"
    environment = "dev"
  }
}

# ====================================================================
# 6. NAT Gateway Variables  
# ====================================================================

variable "nat_gateway_1_tags" {
  type = map(string)
  default = {
    Name        = "nat-gateway-1"
    environment = "dev"
  }
}

variable "nat_gateway_2_tags" {
  type = map(string)
  default = {
    Name        = "nat-gateway-2"
    environment = "dev"
  }
}

# ====================================================================
# 7. Route table variables  
# ====================================================================

variable "public_route_table_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "public_route_table_tags" {
  type = map(string)
  default = {
    Name        = "public-route-table"
    environment = "dev"
  }
}

variable "private_route_table_1_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

variable "private_route_table_1_tags" {
  type = map(string)
  default = {
    Name        = "private-route-table-1"
    environment = "dev"
  }
}

variable "private_route_table_2_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "private_route_table_2_tags" {
  type = map(string)
  default = {
    Name        = "private-route-table-2"
    environment = "dev"
  }
}

# ====================================================================
# 9. Security Groups Variables
# ====================================================================

variable "public_security_group_name"{
    type = string
    default = "public-security-group"
}

variable "public_security_group_description"{
    type = string
    default = "Allow inbound traffic to public subnets"
}

variable "public_security_group_ingress"{
    type = list(object({
        from_port    = number
        to_port      = number
        protocol     = string
        cidr_blocks  = list(string)
    }))
    default = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "public_security_group_egress" {
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = [
        {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "private_security_group_name" {
  type = string
  default = "private-security-group"
}

variable "private_security_group_description" {
    type = string
    default = "Allow inbound traffic to private subnets"
}

variable "private_security_group_ingress" {
    type = list(object({
        from_port    = number
        to_port      = number
        protocol     = string
        cidr_blocks  = list(string)
    }))
    default = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "private_security_group_egress" {
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = [
        {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    ]
}

variable "public_egress_type" {
    type = string
    default = "egress"
}

variable "public_egress_from_port" {
    type = number
    default = 0
}

variable "public_egress_to_port" {
    type = number
    default = 0
}

variable "public_egress_protocol" {
    type = string
    default = "-1"
}

variable "public_egress_cidr_blocks" {
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "private_egress_type" {
    type = string
    default = "egress"
}

variable "private_egress_from_port" {
    type = number
    default = 0
}

variable "private_egress_to_port" {
    type = number
    default = 0
}

variable "private_egress_protocol" {
    type = string
    default = "-1"
}

variable "private_egress_cidr_blocks" {
    type = list(string)
    default = ["0.0.0.0/0"]
}

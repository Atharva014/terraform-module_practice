# VPC creation
resource "aws_vpc" "atharva_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "atharva-vpc"
  }
}

# Internet Gateway creation
resource "aws_internet_gateway" "atharva_vpc_igw" {
  vpc_id = aws_vpc.atharva_vpc.id
  tags = {
    Name = "atharva-vpc-igw"
  }
}

# Subnet creation
resource "aws_subnet" "atharva_vpc_web_public_sub" {
  count = var.sub_count
  vpc_id = aws_vpc.atharva_vpc.id
  cidr_block = var.web_pub_sub_cidr[count.index]
  availability_zone = var.pub_sub_az[count.index]
  map_public_ip_on_launch = var.public_ip_on_launch
  enable_resource_name_dns_a_record_on_launch = var.resource_name_dns_a_record_on_launch
  tags = {
    Name = "atharva-vpc-web-public-sub-${count.index}"
  }
}

resource "aws_subnet" "atharva_vpc_app_private_sub" {
  count = var.sub_count  
  vpc_id = aws_vpc.atharva_vpc.id
  cidr_block = var.app_priv_sub_cidr[count.index]
  availability_zone = var.priv_sub_az[count.index]
  enable_resource_name_dns_a_record_on_launch = var.resource_name_dns_a_record_on_launch
  tags = {
    Name = "atharva-vpc-app-private-sub-${count.index}"
  }
}

resource "aws_subnet" "atharva_vpc_db_private_sub" {
  count = var.sub_count  
  vpc_id = aws_vpc.atharva_vpc.id
  cidr_block = var.db_priv_sub_cidr[count.index]
  availability_zone = var.priv_sub_az[count.index]
  enable_resource_name_dns_a_record_on_launch = var.resource_name_dns_a_record_on_launch
  tags = {
    Name = "atharva-vpc-db-private-sub-${count.index}"
  }
}

# Elastic ip creation
resource "aws_eip" "atharva_vpc_eip" {
  count = var.sub_count
  domain = "vpc"
}

# NAT getway creation
resource "aws_nat_gateway" "atharva_vpc_web_ngw" {
  count = var.sub_count
  allocation_id = aws_eip.atharva_vpc_eip[count.index].id
  subnet_id = aws_subnet.atharva_vpc_web_public_sub[count.index].id
  tags = {
    Name = "atharva-vpc-ngw-${count.index}"
  }
  depends_on = [ aws_internet_gateway.atharva_vpc_igw ]
}

# Route table creation
resource "aws_route_table" "atharva_vpc_web_public_rt" {
  vpc_id = aws_vpc.atharva_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atharva_vpc_igw.id
  }
  tags = {
    Name = "atharva-vpc-web-public-rt"
  }
}

resource "aws_route_table" "atharva_vpc_app_private_rt" {
  count = var.sub_count
  vpc_id = aws_vpc.atharva_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.atharva_vpc_web_ngw[count.index].id
  }
  tags = {
    Name = "atharva-vpc-app-private-rt-${count.index}"
  }
}

resource "aws_route_table" "atharva_vpc_db_private_rt" {
  count = var.sub_count
  vpc_id = aws_vpc.atharva_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.atharva_vpc_web_ngw[count.index].id
  }
  tags = {
    Name = "atharva-vpc-db-private-rt-${count.index}"
  }
}

# Route table association
resource "aws_route_table_association" "web_pub_rt_association" {
  count = var.sub_count
  subnet_id = aws_subnet.atharva_vpc_web_public_sub[count.index].id
  route_table_id = aws_route_table.atharva_vpc_web_public_rt.id
}

resource "aws_route_table_association" "app_pri_rt_association" {
  count = var.sub_count
  subnet_id = aws_subnet.atharva_vpc_app_private_sub[count.index].id
  route_table_id = aws_route_table.atharva_vpc_app_private_rt[count.index].id
}

resource "aws_route_table_association" "db_pri_rt_association" {
  count = var.sub_count
  subnet_id = aws_subnet.atharva_vpc_db_private_sub[count.index].id
  route_table_id = aws_route_table.atharva_vpc_db_private_rt[count.index].id
}

# Security Group creation
resource "aws_security_group" "atharva_vpc_sg" {
  name = "atharva_vpc_ssh_sg"
  description = "Allow ssh traffic from outside"
  vpc_id = aws_vpc.atharva_vpc.id
  tags = {
    Name = "atharva-vpc-allow_ssh"
  }
}

# Security Group rules creation
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_traffic" {
  security_group_id = aws_security_group.atharva_vpc_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  to_port = 22
  from_port = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.atharva_vpc_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
// Internet Gateway importado do IGW existente
resource "aws_internet_gateway" "igw-08734f3497551acbd" {

    vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id

    tags = {
        Name = "igw-poc-test-sa-east-1"
    }
}

// Criando o roteamento do EKS para internet 
resource "aws_route_table" "eks_igw_route_table" {
    vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id

    tags = {
        Name = format("%-spublic-route", var.cluster_name)
    }
}

resource "aws_route" "eks_public_internet_access" {

    route_table_id = aws_route_table.eks_igw_route_table.id

    destination_cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw-08734f3497551acbd.id
}
// criando o Elastic IP
resource "aws_eip" "vpc_eip" {
    vpc = true

    tags = {
        Name = format("%s-eip", var.cluster_name)
    }
  
}


// Criando o NAT Gateway

resource "aws_nat_gateway" "eks_nat" {
    allocation_id = aws_eip.vpc_eip.id
    subnet_id       = aws_subnet.subnet-public-poc-test-eks-1c.id  

        tags = {
        Name = format("%s-nat-gateway", var.cluster_name)
    }
}

resource "aws_route_table" "eks_nat" {
    vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id
    tags = {
        Name = format("%s-private-route", var.cluster_name)
    }
  
}

resource "aws_route" "eks_nat_access" {
    route_table_id =  aws_route_table.eks_nat.id
    destination_cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.eks_nat.id
}

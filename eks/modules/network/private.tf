// Esta rede tera acesso a internet via Nat Gateway
resource "aws_subnet" "subnet-private-cluster-test-eks-1a"{
  vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id
    cidr_block = "10.88.96.0/20"

  availability_zone = format("%sa", var.aws_region)
  tags = {
      "Name" = format("%s-private-1a", var.cluster_name  ),
      "kubenetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
  resource "aws_subnet" "subnet-private-cluster-test-eks-1c"{
  vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id
    cidr_block = "10.88.112.0/20"


  availability_zone = format("%sc", var.aws_region)
  tags = {
      "Name" = format("%s-private-1c", var.cluster_name  ),
      "kubenetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

// Associando a regra de roteamento as subnets publicas.
  resource "aws_route_table_association" "private_eks_1a" {
    subnet_id = aws_subnet.subnet-private-cluster-test-eks-1a.id
    route_table_id = aws_route_table.eks_nat.id

 }

  resource "aws_route_table_association" "private_eks_1c" {
    subnet_id = aws_subnet.subnet-private-cluster-test-eks-1c.id
    route_table_id = aws_route_table.eks_nat.id

 }
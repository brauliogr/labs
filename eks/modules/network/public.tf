resource "aws_subnet" "subnet-public-cluster-test-eks-1a"{
  vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id
  cidr_block = "10.88.64.0/20"

// Mapeia um ip publico sempre que um host for lançado dentro da subnet
  map_public_ip_on_launch = true

  availability_zone = format("%sa", var.aws_region)
  tags = {
      "Name" = format("%s-public-1a", var.cluster_name  ),
      "kubenetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = "1"
  }
}

  resource "aws_subnet" "subnet-public-cluster-test-eks-1c" {
    vpc_id = aws_vpc.vpc-01be47c3c04744fbf.id
    cidr_block = "10.88.80.0/20"

// Mapeia um ip publico sempre que um host for lançado dentro da subnet
    map_public_ip_on_launch = true

    availability_zone = format("%sc", var.aws_region)
    tags = {
          "Name" = format("%s-public-1c", var.cluster_name  ),
          "kubenetes.io/cluster/${var.cluster_name}" = "shared"
          "kubernetes.io/role/elb" = "1"
          
  }
}

// Associando a regra de roteamento as subnets publicas.
  resource "aws_route_table_association" "public_eks_1a" {
    subnet_id = aws_subnet.subnet-public-cluster-test-eks-1a.id
    route_table_id = aws_route_table.eks_igw_route_table.id

 }

  resource "aws_route_table_association" "public_eks_1c" {
    subnet_id = aws_subnet.subnet-public-cluster-test-eks-1c.id
    route_table_id = aws_route_table.eks_igw_route_table.id

 }
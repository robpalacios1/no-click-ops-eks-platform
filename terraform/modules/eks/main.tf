# ====================================================================
# 1. Create IAM Role for EKS Cluster
# ====================================================================

resource "aws_iam_role" "eks_cluster_role" {
    name = "dev-eks-cluster-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = "dev-eks-cluster-role"
        environment = "dev"
    }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ====================================================================
# 2. Create IAM Role for EKS Node Group
# ====================================================================

resource "aws_iam_role" "eks_node_role" {
    name = "dev-eks-node-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = "dev-eks-node-role"
        environment = "dev"
    }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_read_only_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ====================================================================
# 3. Create EKS Cluster
# ====================================================================

resource "aws_eks_cluster" "dev-eks-cluster" {
    name = "dev-eks-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = "1.35"

    vpc_config {
        subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef0"]
        endpoint_private_access = true
        endpoint_public_access = true
    }

    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]

    tags = {
        Name = "dev-eks-cluster"
        environment = "dev"
    }
}

# ====================================================================
# 4. Create EKS Node Group
# ====================================================================

resource "aws_eks_node_group" "dev-eks-node-group" {
    cluster_name    = aws_eks_cluster.dev-eks-cluster.name
    node_group_name = "dev-eks-node-group"
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef0"]
    instance_types  = ["t3.micro"]
    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.eks_worker_node_policy, 
        aws_iam_role_policy_attachment.eks_cni_policy, 
        aws_iam_role_policy_attachment.eks_read_only_policy 
    ]

    tags = {
        Name = "dev-eks-node-group"
        environment = "dev"
    }
}
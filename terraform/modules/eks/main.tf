# ====================================================================
# 1. Create IAM Role for EKS Cluster
# ====================================================================

resource "aws_iam_role" "eks_cluster_role" {
    name = var.eks_cluster_role_name

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

    tags = var.eks_cluster_role_tags
}
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = var.eks_cluster_policy_arn
}

# ====================================================================
# 2. Create IAM Role for EKS Node Group
# ====================================================================

resource "aws_iam_role" "eks_node_role" {
    name = var.eks_node_role_name

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

    tags = var.eks_node_role_tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = var.eks_worker_node_policy_arn
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = var.eks_cni_policy_arn
}

resource "aws_iam_role_policy_attachment" "eks_read_only_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = var.eks_read_only_policy_arn
}

# ====================================================================
# 3. Create EKS Cluster
# ====================================================================

resource "aws_eks_cluster" "dev-eks-cluster" {
    name = var.dev_eks_cluster_name
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = var.dev_eks_cluster_version

    vpc_config {
        subnet_ids = var.dev_eks_cluster_subnet_ids
        endpoint_private_access = var.dev_eks_cluster_endpoint_private_access
        endpoint_public_access = var.dev_eks_cluster_endpoint_public_access
    }

    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]

    tags = var.dev_eks_cluster_tags
}

# ====================================================================
# 4. Create EKS Node Group
# ====================================================================

resource "aws_eks_node_group" "dev-eks-node-group" {
    cluster_name    = aws_eks_cluster.dev-eks-cluster.name
    node_group_name = var.dev_eks_node_group_name
    node_role_arn   = aws_iam_role.eks_node_role.arn
    subnet_ids      = var.dev_eks_node_group_subnet_ids
    instance_types  = var.dev_eks_node_group_instance_types
    scaling_config {
        desired_size = var.dev_eks_node_group_scaling_config["desired_size"]
        max_size     = var.dev_eks_node_group_scaling_config["max_size"]
        min_size     = var.dev_eks_node_group_scaling_config["min_size"]
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
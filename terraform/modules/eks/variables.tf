# ====================================================================
# 1. IAM Role for EKS Cluster Variables
# ====================================================================

variable "eks_cluster_role_name" {
    description = "Name of the EKS cluster"
    type        = string
    default = "dev-eks-cluster-role"
}

variable "eks_cluster_role_tags" {
    type = map(string)
    default = {
        Name = "dev-eks-cluster-role"
        environment = "dev"
    }
}

variable "eks_cluster_policy_arn" {
    description = "ARN of the IAM role for EKS cluster"
    type        = string
    default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ====================================================================
# 2. IAM Role for EKS Node Group Variables
# ====================================================================

variable "eks_node_role_name" {
    description = "Name of the EKS node role"
    type        = string
    default = "dev-eks-node-role"
}

variable "eks_node_role_tags" {
    type = map(string)
    default = {
        Name = "dev-eks-node-role"
        environment = "dev"
    }
}

variable "eks_worker_node_policy_arn" {
    description = "ARN of the IAM role for EKS worker node"
    type        = string
    default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "eks_cni_policy_arn" {
    description = "ARN of the IAM role for EKS CNI"
    type        = string
    default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

variable "eks_read_only_policy_arn" {
    description = "ARN of the IAM role for EKS read only"
    type        = string
    default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ====================================================================
# 3. EKS Cluster Variables
# ====================================================================

variable "dev_eks_cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default = "dev-eks-cluster"
}

variable "dev_eks_cluster_version" {
    description = "Version of the EKS cluster"
    type        = string
    default = "1.35"
}

variable "dev_eks_cluster_subnet_ids" {
    description = "List of subnet IDs for the EKS cluster"
    type        = list(string)
}

variable "dev_eks_cluster_endpoint_private_access" {
    description = "Enable private access to the EKS cluster"
    type        = bool
    default = true
}

variable "dev_eks_cluster_endpoint_public_access" {
    description = "Enable public access to the EKS cluster"
    type        = bool
    default = true
}

variable "dev_eks_cluster_tags" {
    type = map(string)
    default = {
        Name = "dev-eks-cluster"
        environment = "dev"
    }
}

# ====================================================================
# 4. EKS Node Group Variables
# ====================================================================

variable "dev_eks_node_group_name" {
    description = "Name of the EKS node group"
    type        = string
    default = "dev-eks-node-group"
}

variable "dev_eks_node_group_subnet_ids" {
    description = "List of subnet IDs for the EKS node group"
    type        = list(string)
}

variable "dev_eks_node_group_instance_types" {
    description = "List of instance types for the EKS node group"
    type        = list(string)
    default = ["t3.micro"]
}

variable "dev_eks_node_group_scaling_config" {
    description = "Scaling configuration for the EKS node group"
    type        = object({
        desired_size = number
        max_size     = number
        min_size     = number
    })
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
    }
}

variable "dev_eks_node_group_tags" {
    type = map(string)
    default = {
        Name = "dev-eks-node-group"
        environment = "dev"
    }
}
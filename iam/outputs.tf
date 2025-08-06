output "eks_cluster_role_arn" {
	description = "EKS cluster role ARN"
	value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_group_role_arn" {
	description = "EKS node group role ARN"
	value       = aws_iam_role.eks_node_group.arn
}
variable "name_prefix" {
	description = "Prefix for resource names"
	type        = string
}

variable "vpc_id" {
	description = "VPC ID where security groups will be created"
	type        = string
}
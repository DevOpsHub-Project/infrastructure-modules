variable "cidr_block" {
	description = "VPC CIDR block"
	type        = string
}

variable "name" {
	description = "VPC name"
	type        = string
}

variable "public_subnet_count" {
	description = "Number of public subnets"
	type        = number
	default     = 2
}

variable "private_subnet_count" {
	description = "Number of private subnets"
	type        = number
	default     = 2
}

variable "enable_nat_gateway" {
	description = "Enable NAT Gateway for private subnets"
	type        = bool
	default     = true
}

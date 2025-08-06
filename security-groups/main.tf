terraform {
	required_version = ">= 1.5.0"
				  
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.0"
		}
	}
				  
}

# Web tier security group
resource "aws_security_group" "web" {
	name_prefix = "${var.name_prefix}-web-"
	vpc_id      = var.vpc_id
	description = "Security group for web tier"

	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	    from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
	    from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "${var.name_prefix}-web-sg"
		Tier = "Web"
	}
}

# Application tier security group
resource "aws_security_group" "app" {
    name_prefix = "${var.name_prefix}-app-"
	vpc_id      = var.vpc_id
	description = "Security group for application tier"

	ingress {
		from_port       = 8080
		to_port         = 8080
		protocol        = "tcp"
		security_groups = [aws_security_group.web.id]
	}

	egress {
	    from_port   = 0
	    to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
	    Name = "${var.name_prefix}-app-sg"
		Tier = "Application"
	}
}

# Database tier security group
resource "aws_security_group" "db" {
	name_prefix = "${var.name_prefix}-db-"
	vpc_id      = var.vpc_id
	description = "Security group for database tier"

	ingress {
		from_port       = 5432
		to_port         = 5432
		protocol        = "tcp"
		security_groups = [aws_security_group.app.id]
	}

	tags = {
		Name = "${var.name_prefix}-db-sg"
		Tier = "Database"
		}
}
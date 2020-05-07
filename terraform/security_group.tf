# RDSに設定するセキュリティグループ
resource "aws_security_group" "posgre_security_group" {
  name   = "${var.name}-posgre-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "tcp"
    cidr_blocks     = ["10.1.0.0/16"]
  }

  egress {
      from_port      = 0
      to_port        = 0
      protocol       = "-1"
      cidr_blocks    = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-posgre-sg"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.name}-alb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port      = 0
      to_port        = 0
      protocol       = "-1"
      cidr_blocks    = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-alb-sg"
  }
}

output "db_sg_id" {
  value = aws_security_group.posgre_security_group.id
}

# bastionに設定するセキュリティグループ
resource "aws_security_group" "bastion_security_group" {
  name   = "${var.name}-${var.bastion_name}-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-${var.bastion_name}-sg"
  }
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_security_group.id
}

# ecsに設定するセキュリティグループ
resource "aws_security_group" "ecs" {
  name   = "${var.name}-ecs-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "tcp"
    cidr_blocks     = ["10.1.0.0/16"]
  }

  egress {
      from_port      = 0
      to_port        = 0
      protocol       = "-1"
      cidr_blocks    = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-ecs-sg"
  }
}

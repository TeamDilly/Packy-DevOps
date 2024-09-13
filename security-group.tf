resource "aws_security_group" "packy-v2-ecs-sg" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ] # TODO: 로드밸런서 sg랑 연결
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      Name = "packy-v2-ecs-sg"
    }
}

resource "aws_security_group" "packy-v2-web-sg" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

        ingress {
        from_port = 3001
        to_port = 3001
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      Name = "packy-v2-web-sg"
    }
}

resource "aws_security_group" "packy-v2-alb-sg" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      Name = "packy-v2-alb-sg"
    }
}

resource "aws_security_group_rule" "packy-v2-alb-to-web-http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.packy-v2-web-sg.id
  source_security_group_id = aws_security_group.packy-v2-alb-sg.id
}

resource "aws_security_group_rule" "packy-v2-alb-to-web-https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.packy-v2-web-sg.id
  source_security_group_id = aws_security_group.packy-v2-alb-sg.id
}
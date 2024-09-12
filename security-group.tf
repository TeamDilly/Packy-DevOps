resource "aws_security_group" "packy-v2-ecs-sg" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: 로드밸런서 sg랑 연결
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "packy-v2-ecs-sg"
    }
}
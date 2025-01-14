resource "aws_iam_role" "ecs-instance-role" {
    name = "ecsInstanceRole"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
    }]
    })
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-policy" {
    role = aws_iam_role.ecs-instance-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"  
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
    name = "ecs-instance-profile"
    role = aws_iam_role.ecs-instance-role.name
}

# resource "aws_instance" "packy-v2-ecs-dev-ec2" {
#     # TODO: ECS Optimized AMI로 변경
#     ami = "ami-0023481579962abd4" # Amazon Linux 2023 AMI
#     instance_type = "t2.micro"
#     subnet_id = aws_subnet.packy-v2-public-subnet-01.id
    
#     vpc_security_group_ids = [aws_security_group.packy-v2-ecs-sg.id]

#     iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name

#     key_name = "packy-v2-key-pair"

#     user_data = <<-EOF
#     #!/bin/bash
#     echo ECS_CLUSTER=${aws_ecs_cluster.packy-v2-ecs-cluster.name} >> /etc/ecs/ecs.config
#     EOF

#     tags = {
#       Name = "packy-v2-ecs-dev-ec2"
#     }
# }

resource "aws_eip" "packy-v2-eip" {
    instance = aws_instance.packy-v2-web-ec2.id
}

resource "aws_instance" "packy-v2-web-ec2" {
    ami = "ami-0023481579962abd4" # Amazon Linux 2023 AMI
    instance_type = "t2.micro"
    subnet_id = aws_subnet.packy-v2-public-subnet-01.id
    
    vpc_security_group_ids = [ aws_security_group.packy-v2-web-sg.id ]

    iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name

    key_name = "packy-v2-key-pair"

    user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -aG docker ec2-user
    sudo yum install aws-cli -y
    EOF

    tags = {
      Name = "packy-v2-web-ec2"
    }
}
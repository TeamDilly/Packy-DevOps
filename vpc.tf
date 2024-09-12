resource "aws_vpc" "packy-v2-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "packy-v2-vpc"
    }
}

resource "aws_subnet" "packy-v2-public-subnet-01" {
  vpc_id = aws_vpc.packy-v2-vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = true # 퍼블릭 IP 자동 할당

  tags = {
    Name = "packy-v2-public-subnet-01"
  }
}

resource "aws_subnet" "packy-v2-public-subnet-02" {
  vpc_id = aws_vpc.packy-v2-vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "packy-v2-public-subnet-02"
  }
}

resource "aws_internet_gateway" "packy-v2-igw" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    tags = {
      Name = "packy-v2-igw"
    }
}

resource "aws_route_table" "packy-v2-public-rt" {
    vpc_id = aws_vpc.packy-v2-vpc.id

    tags = {
      Name = "packy-v2-public-rt"
    }
}

resource "aws_route_table_association" "packy-v2-public-rt-subnet-01" {
  subnet_id = aws_subnet.packy-v2-public-subnet-01.id
  route_table_id = aws_route_table.packy-v2-public-rt.id
}

resource "aws_route_table_association" "packy-v2-public-rt-subnet-02" {
  subnet_id = aws_subnet.packy-v2-public-subnet-02.id
  route_table_id = aws_route_table.packy-v2-public-rt.id
}

resource "aws_route" "packy-v2-internet-access" {
  route_table_id = aws_route_table.packy-v2-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.packy-v2-igw.id
}

resource "aws_subnet" "packy-v2-private-subnet-01" {
  vpc_id = aws_vpc.packy-v2-vpc.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "packy-v2-private-subnet-01"
  }
}
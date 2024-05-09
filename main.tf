provider "aws" {
    region = "ap-southeast-2"
    access_key = "secret_key"
    secret_key = "accedss{_key}"

}



resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
   Name = "vpc_1"
}
}

resource "aws_subnet" "sub_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "sub_1"
  }
}

resource "aws_subnet" "sub_2" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "sub_2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

tags = {
  Name = "rt1"
}
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sub_1.id
  route_table_id = aws_route_table.rt1.id
}

data "aws_ami" "aws_os" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240429.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "public-ec2" {
  ami           = data.aws_ami.aws_os.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_1.id
  key_name = "terraform-1"

  availability_zone = "ap-southeast-2a"

  associate_public_ip_address = true

  tags = {
    Name = "public-ec2"
  }
}

resource "aws_instance" "private-ec2" {
  ami           = data.aws_ami.aws_os.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_2.id
  key_name = "terraform-1"

  availability_zone = "ap-southeast-2b"

  associate_public_ip_address = false

  tags = {
    Name = "private-ec2"
  }
}

resource "aws_key_pair" "terraform_1" {
  key_name   = "terraform-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDljpepyrptBZcNQMXXEkTOmNkaRHm40yYDU7M33pQerRa7pd4hTEnXgm7qiAKphgqzC8M+rcoB7iM9rIfEU/DzC5skOGVCEI4oLhZAfIkCUkVeilQEE+2qxXEDJy2pUUM74IH9KlqnwNP8ZRVF0QVi3BblWrxecTifhPNszaEqvPDjXfI85NvrCrQ7LcurZn0PkKhoYxLijWq2lr5OGePff9/hou4NI2oumjPLpruK1/aiUafpwhgLXlpu2le8xXV+R24XQXWL/T1zWhQWhcT0kh+YfbhsiwEev4CR2pGk+J+qTO+fsFq36o2UoH5NQab/3Jx+NCOTdWo2FbeR+1uKnR2TJP5eoLUO/GbW/Q9cNLYQxS56/TDmD506V/pUANASDlPFTplGr765ka3weZ5qISgCSo/d1VQn+AYcnubVDXdcYzDSBVIMJcjK5v1i64paADiKRBnaNB9Xx37pjxUvlEHvez/Lg1Y1a+i9Vw+HWuzUI86wbZENC7bp/HOo/xz5v+EwTUNKuVJ/CxqwzF0uLshD7hUeY1GWDmBVq2TTzZbm84/5hadp8AicyRxnFz/7GdTA61ocrTv7lIg6Zd0jgGpMOvI+J4Lzvsgq8wnNezHofE7g27J7cSHGWTQqhixH7E7ET1HLh/LcM5VxTsRlqN2vDOXn4l8XX6QlUpoMaw== Welcome@DESKTOP-JNFGD0Q"
} 




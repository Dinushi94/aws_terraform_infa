#aws vpc resource
resource "aws_vpc" "infa_terraf_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

#aws resource public subnet
resource "aws_subnet" "infa_terraf_public_subnet" {
  vpc_id                  = aws_vpc.infa_terraf_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "main-public"
  }
}

#AWS Internet Gateway Resource
resource "aws_internet_gateway" "infa_terraf_internet_gateway" {
  vpc_id = aws_vpc.infa_terraf_vpc.id

  tags = {
    Name = "main-igw"
  }
}

#aws resource route table
resource "aws_route_table" "infa_terraf_public_rt" {
  vpc_id = aws_vpc.infa_terraf_vpc.id

  tags = {
    Name = "main-rt"
  }
}

#aws resource creat route 
resource "aws_route" "infa_terraf_default_route" {
  route_table_id         = aws_route_table.infa_terraf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.infa_terraf_internet_gateway.id
}

#Lets associate our route and route table
resource "aws_route_table_association" "infa_terraf_public_assoc" {
  subnet_id      = aws_subnet.infa_terraf_public_subnet.id
  route_table_id = aws_route_table.infa_terraf_public_rt.id
}

#create aws key pair using terraform funtion 
resource "aws_key_pair" "infa_auth" {
  key_name   = "infakey"
  public_key = file("~/.ssh/infakey.pub")

}

#Deploye the ec2 
resource "aws_instance" "main_server" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.infa_ec2.id

  key_name               = aws_key_pair.infa_auth.id
  vpc_security_group_ids = [aws_security_group.infa_terraf_sg.id]
  subnet_id              = aws_subnet.infa_terraf_public_subnet.id
  #will extract the data from the userdata.tpl file and use that for the bootstrap our server 
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "main-server"
  }

  provisioner "local-exec" {
    command = templatefile("windows-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identifyFile = "~/.ssh/infakey"
    })
    interpreter = ["Powershell", "-Command"]


  }

}
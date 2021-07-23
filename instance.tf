provider "aws" {
    region = "us-east-1"
}

resource "aws_security_group" "calvin_ssh" {
    name        = "calvin_ssh_access"
    description = "Allow ssh traffic"

    ingress {
        from_port   =   22
        to_port     =   22
        protocol    =   "tcp"
        cidr_blocks =   ["24.4.225.29/32"]
    }

    ingress {
        from_port   =   9966
        to_port     =   9966
        protocol    =   "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    egress {
        from_port   =   0
        to_port     =   0
        protocol    =   "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags = {
        Name = "calvin_ssh_access"
    }
}

resource "aws_instance" "calvin_instance" {
    ami             = "ami-00e87074e52e6c9f9"
    instance_type   = "t2.micro"
    key_name        = "calvin-keypair"
    count           = "3"

    tags = {
        Name = "yaks-ansible-node-${count.index + 1}"
    }

    vpc_security_group_ids = [aws_security_group.calvin_ssh.id]
}


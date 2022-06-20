terraform {
   required_providers {
         aws = {
              source = "hashicorp/aws"
          }
      }
 }
    provider "aws" {
          region = "us-west-2"
          profile = "default"
          }
    resource "aws_vpc" "fithealthvpc" {
           cidr_block = "172.0.0.0/16"
}
    resource "aws_subnet" "fithealthpriv1" {
         vpc_id = aws_vpc.fithealthvpc.id
         cidr_block = "172.0.1.0/24"
 }
    resource "aws_security_group" "sshpubsg" {
         vpc_id = aws_vpc.fithealthvpc.id
          ingress {
              from_port = 0
              to_port = 65535
              protocol = "tcp"
              cidr_blocks = ["0.0.0.0/0"]
    } 
          egress {
              from_port = 0
              to_port = 0
              protocol = "-1"
              cidr_blocks = ["0.0.0.0/0"]
   }
}
    resource "aws_key_pair" "devopskeypair" {
              key_name = "devopspk"
              public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQPLaa/dkhdutySv32RVY9QF0hfawbUF2kvN9AwX/SsnN9OY4yUKfdgsSaPAW8UVyCab7O9BddmsG6JnrwSB3oFMbVv/8KENY77B0dbgQaipZOcAZF35NO7WG+uTsaPio2gtJZzyY5ds/c1WTgPCK2ObrfdPaCWvMlhrlvh+G+y9+uqWqT+pfMk89PcxMQxIVTpm6LKEbtQurdsBBkCX9hLy4DuVlQgehnajICROUhL9U983A8jp4mWrSed61grZ0TBs/RjmeukP3A9stgaRlH7hMDvqosle7jiATIRoarSfO1NkF8mrE2p+mP2QXrrIG5NWFyA1pqltiLyIalwB62uxWNU2t9AkL/9TTz+/HAFKABzObRNWbcw7S3IGmSFuSiyOcqZ0GCvf5Fd0Rnx4eo4hzGRkqXvTekxJUEAnd2I1KZcDx2XfmWJJujCWHZTC+PSvavEuq3XDGMof5F1rex0HpdegYuOUhpE5abGtPMVf6WR0+f8TqQLuLmPg6NIpE= SRS@DESKTOP-99M97DV"
}
    resource "aws_instance" "fithealthec2" {
               subnet_id = aws_subnet.fithealthpriv1.id               
               instance_type = "t2.micro"
               ami = "ami-00af37d1144686454"
               vpc_security_group_ids = [aws_security_group.sshpubsg.id]
               key_name = aws_key_pair.devopskeypair.key_name
}



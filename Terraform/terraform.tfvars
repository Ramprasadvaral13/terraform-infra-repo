region     = "us-east-1"
vpc_cidr   = "10.0.0.0/16"
route_cidr = "0.0.0.0/0"

subnets = {
  "public-1" = {
    cidr   = "10.0.1.0/24"
    az     = "us-east-1a"
    public = true
  },
  "private-1" = {
    cidr   = "10.0.2.0/24"
    az     = "us-east-1a"
    public = false
  }
}

ami_id           = "ami-020cba7c55df1f615" # ubuntu
instance_type    = "t2.micro"
min_size         = 2
max_size         = 4
desired_capacity = 2
root_volume_size = 10
user_data        = <<EOF
#!/bin/bash
sudo apt update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx
EOF

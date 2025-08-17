variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "route_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr   = string
    az     = string
    public = bool
  }))
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "root_volume_size" {
  type = number
}

variable "user_data" {
  type = string
}


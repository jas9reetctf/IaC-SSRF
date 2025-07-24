variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
   type        = string
   description = "Ubuntu 22.04"
   default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
   type        = string
   description = "Instance type"
   default     = "t2.micro"
}

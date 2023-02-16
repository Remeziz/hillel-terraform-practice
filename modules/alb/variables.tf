variable "name" {
  type        = string
  description = "description"
}

variable "supported_instance_types" {
  type    = list(string)
  default = ["t2.micro"]
}

variable "instance_ids" {
  type    = list(string)
  default = []
}

variable "instance_sg_id" {
  type = string
}


variable "my_ip" {
  type = string
}

variable "port_tg" {
  type        = string
  default     = "8080"
  description = "port for target group"
}

variable "listen_alb_port" {
  type        = string
  default     = "80"
  description = "alb listen port"
}

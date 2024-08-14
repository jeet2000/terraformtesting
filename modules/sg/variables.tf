variable "name" {
  description = "The name of the security group"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the security group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The VPC ID to create the security group in"
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to the security group"
  type        = map(string)
  default     = {}
}

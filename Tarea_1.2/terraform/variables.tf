variable "aws_region" {
  description = "Region de AWS donde se creara el bucket"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "owner" {
  description = "Unidad del equipo responsable"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket"
  type        = string
}

variable "allowed_source_ips" {
  description = "Lista de CIDRs permitidos."
  type        = list(string)
  default     = []
}
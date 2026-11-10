variable "aws_region" {
  description = "Región donde desplegar la PoC"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefijo de recursos. Usar uno distinto del stack SAM"
  type        = string
  default     = "itba-serverless-demo-tf"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,36}$", var.project_name))
    error_message = "Usá 3-37 caracteres: a-z, 0-9 y guiones; debe comenzar con letra."
  }
}

variable "lambda_role_name" {
  description = "IAM role preexistente en AWS Academy; Terraform NO lo crea"
  type        = string
  default     = "LabRole"
}

variable "lambda_execution_role_arn" {
  description = "Si tu cuenta no tiene LabRole, ARN de un rol Lambda ya creado con permisos para DynamoDB y logs"
  type        = string
  default     = ""
}

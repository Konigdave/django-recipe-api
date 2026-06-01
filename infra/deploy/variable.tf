variable "prefix" {
  description = "A prefix for naming resources."
  type        = string
  default     = "raa"
}

variable "project" {
  description = "The name of the project for tagging resources."
  type        = string
  default     = "recipeapp"
}

variable "contact" {
  description = "Contact information for resource management."
  type        = string
  default     = "admin@recipeapp.com"
}

variable "db_username" {
  description = "Username for the recipe RDS database."
  type        = string
  default     = "recipeappadmin"
}

variable "db_password" {
  description = "Password for the recipe RDS database."
  type        = string
}

variable "ecr_proxy_image" {
  description = "The path of the proxy image in ECR."
  type        = string
}

variable "ecr_app_image" {
  description = "The path of the app image in ECR."
  type        = string
}

variable "django_secret_key" {
  description = "secret key for django"
}

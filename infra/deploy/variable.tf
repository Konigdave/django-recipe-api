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

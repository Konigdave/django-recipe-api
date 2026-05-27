variable "tf_state_bucket" {
    description = "The name of the S3 bucket to store Terraform state files."
    type        = string
    default     = "devops-recipeapp-tfstate"
  
}

variable "tf_state_lock_table" {
    description = "The name of the DynamoDB table to use for Terraform state locking."
    type        = string
    default     = "devops-recipeapp-api-tflock"
  
}

variable "project" {
    description = "The name of the project for tagging resources."
    type        = string
    default     = "recipeapp"
  
}

variable "contact" {
    description = "Contact information for resource management."
    type        = string
    default     = "devops@recipeapp.com"
  
}

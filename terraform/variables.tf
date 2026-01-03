variable "nginx_port" {
  description = "Nginx reverse proxy port"
  type        = number
  default     = 80
}

variable "ollama_port" {
  description = "OLLAMA API port"
  type        = number
  default     = 11434
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "policymaking"
}
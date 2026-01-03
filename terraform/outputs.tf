output "app_url" {
  description = "Application URL via Nginx reverse proxy"
  value       = "http://localhost:${var.nginx_port}"
}

output "api_docs_url" {
  description = "API documentation URL"
  value       = "http://localhost:${var.nginx_port}/docs"
}

output "ollama_url" {
  description = "OLLAMA API URL (direct access)"
  value       = "http://localhost:${var.ollama_port}"
}

output "network_name" {
  description = "Docker network name"
  value       = docker_network.app_net.name
}
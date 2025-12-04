resource "docker_network" "app_net" {
  name = "ai_project_network"
}

# --- OLLAMA ---
resource "docker_image" "ollama" {
  name = "ollama/ollama:latest"
  keep_locally = true
}

resource "docker_container" "ollama" {
  name  = "ollama"
  image = docker_image.ollama.image_id
  networks_advanced { name = docker_network.app_net.name }
  ports {
    internal = 11434
    external = 11434
  }
  volumes {
    # Store data in root/ollama_data
    host_path      = abspath("${path.cwd}/../ollama_data")
    container_path = "/root/.ollama"
  }
}

# --- BACKEND ---
resource "docker_image" "backend" {
  name = "my-backend:latest"
  build {
    context = "${path.cwd}/../backend" # Go up to root, then into backend
  }
}

resource "docker_container" "backend" {
  name  = "backend"
  image = docker_image.backend.image_id
  networks_advanced { name = docker_network.app_net.name }
  ports {
    internal = var.backend_port
    external = var.backend_port
  }
  env = ["OLLAMA_HOST=http://ollama:11434"]
}

# --- FRONTEND ---
resource "docker_image" "frontend" {
  name = "my-frontend:latest"
  build {
    context = "${path.cwd}/../frontend" # Go up to root, then into frontend
  }
}

resource "docker_container" "frontend" {
  name  = "frontend"
  image = docker_image.frontend.image_id
  networks_advanced { name = docker_network.app_net.name }
  ports {
    internal = var.frontend_port
    external = var.frontend_port
  }
}
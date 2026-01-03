resource "docker_network" "app_net" {
  name   = "policymaking-app-network"
  driver = "bridge"
}

# --- NGINX REVERSE PROXY ---
resource "docker_image" "nginx" {
  name = "policymaking-nginx:latest"
  build {
    context = "${path.cwd}/../nginx"
  }
}

resource "docker_container" "nginx" {
  name  = "policymaking-nginx"
  image = docker_image.nginx.image_id
  networks_advanced { name = docker_network.app_net.name }
  ports {
    internal = 80
    external = var.nginx_port
  }
  
  # Ensure ollama, backend and frontend are running and healthy before starting nginx
  depends_on = [
    docker_container.ollama,
    docker_container.backend,
    docker_container.frontend
  ]
  
  restart = "unless-stopped"
}

# --- OLLAMA ---
resource "docker_image" "ollama" {
  name = "policymaking-ollama:latest"
  build {
    context = "${path.cwd}/../ollama"
  }
}

resource "docker_container" "ollama" {
  name  = "ollama"
  image = docker_image.ollama.image_id
  networks_advanced { name = docker_network.app_net.name }
  ports {
    internal = 11434
    external = var.ollama_port
  }
  volumes {
    host_path      = abspath("${path.cwd}/../ollama_data")
    container_path = "/root/.ollama"
  }
  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost:11434/api/tags || exit 1"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
    start_period = "30s"
  }
  restart = "unless-stopped"
}

# --- BACKEND ---
resource "docker_image" "backend" {
  name = "policymaking-backend:latest"
  build {
    context = "${path.cwd}/../backend"
  }
}

resource "docker_container" "backend" {
  name  = "policymaking-backend"
  image = docker_image.backend.image_id
  networks_advanced { name = docker_network.app_net.name }
  env = ["OLLAMA_HOST=http://ollama:11434"]
  
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:8000/docs"]
    interval = "10s"
    timeout  = "5s"
    retries  = 3
  }
  
  depends_on = [docker_container.ollama]
  
  restart = "unless-stopped"
}

# --- FRONTEND ---
resource "docker_image" "frontend" {
  name = "policymaking-frontend:latest"
  build {
    context = "${path.cwd}/../frontend"
  }
}

resource "docker_container" "frontend" {
  name  = "policymaking-frontend"
  image = docker_image.frontend.image_id
  networks_advanced { name = docker_network.app_net.name }
  env = [
    "CHOKIDAR_USEPOLLING=true",
    "REACT_APP_API_URL=/api"
  ]
  
  depends_on = [docker_container.backend]
  
  restart = "unless-stopped"
}
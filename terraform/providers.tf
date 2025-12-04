terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # Windows: "npipe:////./pipe/docker_engine"
  # Mac/Linux: "unix:///var/run/docker.sock"
  host = "unix:///var/run/docker.sock"
}
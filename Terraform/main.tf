###
### terraform plan -var-file="secret.tfvars"
###
# Set the required provider and versions
terraform {
  required_providers {
    # We recommend pinning to the specific version of the Docker Provider you're using
    # since new versions are released frequently
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}


provider "docker" {
    host = "npipe:////.//pipe//docker_engine"
    registry_auth {
        address = "registry.gitlab.com"
        username = var.gitlab_username
        password = var.gitlab_password
  }
}

# https://learn.hashicorp.com/tutorials/terraform/sensitive-variables?in=terraform/configuration-language
variable "gitlab_username" {
  description = "Gitlab Gitlab deployment username"
  type        = string
}

# -var-file="secret.tfvars"
# https://learn.hashicorp.com/tutorials/terraform/sensitive-variables?in=terraform/configuration-language
variable "gitlab_password" {
  description = "Gitlab deployment password"
  type        = string
  sensitive   = true
}

variable "gitlab_account" {
  description = "Gitlab account"
  type        = string
}

resource "docker_registry_image" "gitlab" {
  name          = "registry.gitlab.com/${var.gitlab_account}/my_automated_project"
  keep_remotely = true
  build {
    context     = "app"
    no_cache    = true
    pull_parent = true
  }
} 


resource "docker_image" "nginx" {
  name          = docker_registry_image.gitlab.name
  pull_triggers = [docker_registry_image.gitlab.sha256_digest]
  // in your docker_image resource
  depends_on   = [docker_registry_image.gitlab]
}

resource "docker_container" "nginx" {
  name = "seb_container"
  ports {
    internal = 80
    external = 8080
    ip       = "127.0.0.1"
  }
  image = docker_image.nginx.latest
}

output "debug" {
  value = docker_registry_image.gitlab.sha256_digest
}

output "container_http" {
  value = "http://${docker_container.nginx.ports[0].ip}:${docker_container.nginx.ports[0].external}"
}

# cli options for outputs
# https://www.terraform.io/docs/cli/commands/output.html
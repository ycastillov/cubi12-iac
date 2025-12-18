# 1. CONFIGURACIÓN DEL PROVEEDOR
terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.8"
    }
  }
}

provider "render" {
  # Nota: Se recomienda usar variables para estos valores por seguridad
  api_key  = var.render_api_key
  owner_id = var.render_owner_id
}

# RECURSO: BASE DE DATOS POSTGRESQL
resource "render_postgres" "db_proyecto" {
  name     = "cubi12-db-postgres"
  plan     = "starter"
  region   = "oregon"
  version  = "15"

  database_name = "cubi12db_s9wf"
  database_user = "cubi12db_s9wf_user"
}

# 3. RECURSO: BACKEND (API Dockerizada)
resource "render_web_service" "backend_api" {
  name   = "cubi12-backend"
  plan   = "starter"
  region = "oregon"

  runtime_source = {
    docker_runtime = {
      # Se usa Docker para cumplir con la containerización
      auto_deploy = true
      branch      = "main"
      repo_url    = "https://github.com/RonaldoMorales/cubi12-api"
    }
  }

  env_vars = {
    # El formato debe ser un mapa de objetos según tu documentación
    "DB_CONNECTION" = { value = render_postgres.db_proyecto.connection_string }
    "JWT_SECRET" = { value = "secret_only_knewed_by_yourself_and_nobody_else"}
    "NODE_ENV"     = { value = "production" }
  }
}

# 4. RECURSO: FRONTEND (Web Dockerizada)
resource "render_web_service" "frontend_web" {
  name   = "cubi12-frontend"
  plan   = "starter"
  region = "oregon"

  runtime_source = {
    docker_runtime = {
      auto_deploy = true
      branch      = "main"
      repo_url    = "https://github.com/RonaldoMorales/cubi12-front"
    }
  }

  env_vars = {
    # Comunicación: Se apunta a la URL generada por el Backend
    "API_BASE_URL" = { value = render_web_service.backend_api.url }
  }
}
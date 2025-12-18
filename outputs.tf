output "frontend_url" {
  value       = render_web_service.frontend_web.url
  description = "URL del Frontend desplegado"
}

output "backend_url" {
  value       = render_web_service.backend_api.url
  description = "URL del Backend API"
}

output "database_connection" {
  value       = render_postgres.db_proyecto.connection_string
  sensitive   = true
  description = "String de conexión a PostgreSQL"
}
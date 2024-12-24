resource "aws_service_discovery_private_dns_namespace" "api_dns" {
  name = "api.dns"
  vpc  = var.vpc_id
}

resource "aws_service_discovery_service" "api_discovery" {
  name = "api"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.api_dns.id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}
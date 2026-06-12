variable "repositories" {
  description = "List of ECR repository names to create"
  type        = list(string)
  default = [
    "api-gateway",
    "auth-service",
    "product-catalog",
    "order-service",
    "notification-service",
  ]
}

# This prints out loadbalancer DNS hostname for about-me-app deployment

output "portfolio_load_balancer_hostname" {
  value = kubernetes_service.k8s-service-about-me-app.status.0.load_balancer.0.ingress.0.hostname
}

# This prints out loadbalancer DNS hostname for socks shop app deployment

output "socks_load_balancer_hostname" {
  value = kubernetes_service.k8s-service-socks-shop-app.status.0.load_balancer.0.ingress.0.hostname
}

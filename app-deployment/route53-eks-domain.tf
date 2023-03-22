# route 53, sub-domain setup

resource "aws_route53_zone" "about-me-app-domain-name" {
  name = "aboutme.bennielj.me"
}

resource "aws_route53_zone" "socks-shop-domain-name" {
  name = "socksshop.bennielj.me"
}

# this gets the zone_id for the load balancer

data "aws_elb_hosted_zone_id" "elb_zone_id" {
  depends_on = [
    kubernetes_service.k8s-service-about-me-app, kubernetes_service.k8s-service-socks-shop-app
  ]
}

# DNS record for about-me-app

resource "aws_route53_record" "about-me-app-record" {
  zone_id = aws_route53_zone.about-me-app-domain-name.zone_id
  name    = "aboutme.bennielj.me"
  type    = "A"

  alias {
    name                   = kubernetes_service.k8s-service-about-me-app.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}

# DNS record for socks shop app

resource "aws_route53_record" "socks-shop-record" {
  zone_id = aws_route53_zone.socks-shop-domain-name.zone_id
  name    = "socksshop.bennielj.me"
  type    = "A"

  alias {
    name                   = kubernetes_service.k8s-service-socks-shop-app.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}

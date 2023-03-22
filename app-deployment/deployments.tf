# DEPLOYMENT OF ABOUT-ME-APP

# creating kubernetes namespace for the about-me-app

resource "kubernetes_namespace" "k8s-namespace-about-me-app" {
  metadata {
    name = "about-me-app-namespace"
    labels = {
      app = var.app
    }
  }
}





# creating kubernetes deployment for about-me-app

resource "kubernetes_deployment" "about-me-app" {
  metadata {
    name = var.app
    namespace = kubernetes_namespace.k8s-namespace-about-me-app.id
    labels = {
      app = var.app
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app
      }
    }
    template {
      metadata {
        labels = {
          app = var.app
        }
      }
      spec {
        container {
          image = var.docker-image
          name  = var.app
          env {
            name  = "MYSQL_HOST"
            value = "mysql"
          }
          env {
            name  = "MYSQL_PORT"
            value = "3306"
          }
        }
      }
    }
  }
}





# creating kubernetes service for about-me-app

resource "kubernetes_service" "k8s-service-about-me-app" {
  metadata {
    name      = var.app
    namespace = kubernetes_namespace.k8s-namespace-about-me-app.id
  }
  spec {
    selector = {
      app = var.app
    }
    port {
      name = "metrics"
      port        = 80
      target_port = 80
    }
    port {
      name = "mysql"
      port        = 3306
      target_port = 3306
    }
    type = "LoadBalancer"
  }
}



# mysql database for about-me-app

resource "kubernetes_deployment" "about-me-app-db" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.k8s-namespace-about-me-app.id
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name = "mysql"
          image = "mysql:latest"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value = var.mysql-password
          }

          port {
            name = "mysql"
            container_port = 3306
          }

          volume_mount {
            name = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }

        volume {
          name = "mysql-persistent-storage"
          empty_dir {
            medium = "Memory"
          }
        }
      }
    }
  }
}

# creating kubernetes service for about-me-app mysql database

resource "kubernetes_service" "about-me-db-service" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.k8s-namespace-about-me-app.id
  }

  spec {
    selector = {
      app = "mysql"
    }

    port {
      name = "mysql"
      port = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}




# DEPLOYMENT OF THE SOCKS SHOP APP

# Creating kubernetes namespace for the socks shop app

resource "kubernetes_namespace" "k8s-namespace-socks-shop-app" {
  metadata {
    name = "socks-shop"
  }
}

# Create kubectl deployment for the socks shop app

data "kubectl_file_documents" "docs" {
    content = file("complete-demo.yaml")
}

resource "kubectl_manifest" "k8s-deployment-socks-shop-app" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
}

# Creating kubernetes service for socks the shop frontend

resource "kubernetes_service" "k8s-service-socks-shop-app" {
  metadata {
    name      = "front-end"
    namespace = kubernetes_namespace.k8s-namespace-socks-shop-app.id
    annotations = {
      "prometheus.io/scrape" = "true"
    }
    labels = {
      name = "front-end"
    }
  }
  spec {
    selector = {
      name = "front-end"
    }
    port {
      name = "metrics"
      port        = 80
      target_port = 8079
    }
    type = "LoadBalancer"
  }
}

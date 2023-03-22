variable "cluster" {
  default = "eks-cluster"
}
variable "app" {
  type        = string
  description = "Name of application"
  default     = "about-me-app"
}
variable "region" {
  default = "us-east1"
}
variable "docker-image" {
  type        = string
  description = "name of the docker image to deploy"
  default     = "bennielj/about-me-app:v0.1"
}
variable "mysql-password" {
  type        = string
  description = "name of the docker image to deploy"
  default     = "my_db_password"
}

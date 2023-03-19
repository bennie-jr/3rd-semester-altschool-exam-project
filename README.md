# AltSchool of Cloud Engineering 3rd Semester Exam Submission

Welcome to the AltSchool of Cloud Engineering 3rd Semester Exam Submission repository. This repository contains all the files and source code necessary for deploying two applications, portfolio and socks shop, with Kubernetes using an Infrastructure-as-Code (IaC) tool - Terraform.

The aim of this project is to demonstrate the deployment of applications to AWS infrastructure through a CI/CD pipeline. The pipeline is built using CircleCI and has six jobs, which are as follows:

- `build_docker_image`: Builds the Docker image for the portfolio app and pushes it to Dockerhub image repository.
- `create_backend_state_store`: Applies the Terraform script(s) in the terraform-files/backend directory, which creates an S3 backend and DynamoDB for storing and locking state. This job only executes if the backend branch of the repository is triggered.
- `create_infrastructure`: Applies the Terraform script(s) in the terraform-files/infrastructure directory, which creates the required network infrastructure - VPC, IGW, NAT-GW, Elastic IPs, Route tables and routes, subnets, and security groups - as well as configurations for IAM roles, CloudWatch Log group, EKS node group, and EKS cluster.
- `deploy_applications`: Applies the Terraform script(s) in the terraform-files/deployment directory, which deploys the two applications to the EKS cluster created in the previous job. It also creates two subdomains and maps the load balancers from the two applications to the subdomains.
- `configure_monitoring`: Applies the Terraform script(s) in the terraform-files/monitoring directory, which deploys Prometheus and Grafana to the cluster. This will be used for monitoring and observing the performance and uptime of the applications.
- `destroy_everything`: Destroys the whole deployment and infrastructure by executing `terraform destroy --auto-approve` in the terraform-files/monitoring, terraform-files/deployment, and terraform-files/infrastructure directories. This job only executes if the destroy branch of the repository is triggered.

The Terraform files used for the deployment are organized in different directories to optimize deployment using a CI/CD pipeline. The `backend` folder contains the configuration for the S3 bucket and DynamoDB, which will be used as backend and lock for storing the state of the Terraform deployment. The `infrastructure` folder contains the Terraform files for deploying the required infrastructure to AWS, including network components like VPC, IGW, NAT-GW, Elastic IPs, Route tables and routes, subnets, and security groups. The `deployment` folder contains the scripts used for deploying the two applications to the AWS infrastructure, and the `monitoring` folder contains the scripts used to deploy Prometheus and Grafana to the cluster.

## Requirements

To run this project, you will need:

- Terraform
- AWS CLI and an AWS account
- CircleCI
- Prometheus and Grafana
- Docker and Dockerhub
- Kubernetes
- Git and Github
- A domain (namecheap)

## Conclusion

Overall, this project demonstrates the deployment of applications to AWS infrastructure using a CI/CD pipeline, making it easy to manage and maintain.


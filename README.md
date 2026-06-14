
# Django Recipe API on AWS ECS Fargate

Production-style deployment of a Django REST API using AWS ECS Fargate, Terraform, GitHub Actions, Amazon RDS PostgreSQL, and Cloudflare.

![Architecture Diagram](docs/images/architecture-diagram.jpg)

## Overview

This project demonstrates the deployment of a containerized Django REST API on AWS using modern DevOps and Cloud Engineering practices.

The infrastructure is provisioned through Terraform, application deployments are automated through GitHub Actions, and traffic is routed through Cloudflare and an AWS Application Load Balancer into ECS Fargate services running in private subnets.

The project was designed with three goals:

- Learn Infrastructure as Code
- Implement automated CI/CD pipelines
- Build a cost-efficient cloud environment suitable for hosting multiple future projects

## Design Decisions

### Why ECS Fargate?

I wanted container orchestration without managing EC2 instances.

### Why Terraform?

To ensure infrastructure could be version-controlled and reproduced consistently.

### Why Cloudflare instead of Route53 + CloudFront?

This environment is intended to host multiple personal projects under a single domain.

Cloudflare provides:

- DNS management
- SSL certificates
- Edge caching
- DDoS protection

while maintaining significantly lower operational costs than an equivalent AWS-only implementation.

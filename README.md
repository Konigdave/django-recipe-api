
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

## Architecture

![Architecture Diagram](docs/images/Network-Diagram.jpg)

Request Flow:

1. User sends HTTPS request
2. Cloudflare handles DNS resolution and SSL
3. Traffic reaches the AWS Application Load Balancer
4. ALB forwards requests to ECS Fargate tasks
5. Nginx proxies requests to Django
6. Django communicates with PostgreSQL hosted on Amazon RDS

## Infrastructure

| Component | Purpose |
|------------|------------|
| ECS Fargate | Container execution |
| ECR | Container registry |
| RDS PostgreSQL | Persistent data storage |
| ALB | Traffic distribution |
| Terraform | Infrastructure as Code |
| GitHub Actions | CI/CD |
| Cloudflare | DNS, SSL, CDN |

## Challenges & Lessons Learned

Challenge 1: Static Assets Returning 404 Errors

Problem

After deploying the application to ECS Fargate, the Django Admin interface and frontend loaded as unstyled HTML. Browser developer tools showed repeated 404 Not Found errors for CSS and JavaScript assets.

Root Cause

The Nginx configuration used the root directive inside the /static/ location block:

location /static/ {
    root /vol/web/static;
}

When a request such as:



## Future Improvements

Planned enhancements:

- Replace ECS rolling deployments with blue/green deployments
- Add CloudWatch dashboards and alarms
- Introduce centralized logging
- Add ECS autoscaling policies
- Implement automated backup verification
- Expand infrastructure to support multiple applications under subdomains

## Skills Demonstrated

- AWS ECS Fargate
- Amazon RDS PostgreSQL
- Terraform
- Docker
- GitHub Actions
- Cloudflare
- Infrastructure as Code
- CI/CD
- Reverse Proxy Configuration
- Linux
- Networking
- SSL/TLS

## Repository Structure

.
├── app/
├── proxy/
├── deploy/
├── .github/workflows/
├── terraform/
└── README.md

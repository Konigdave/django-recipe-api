
# Django Recipe API on AWS ECS Fargate

Production-style deployment of a Django REST API using AWS ECS Fargate, Terraform, GitHub Actions, Amazon RDS PostgreSQL, and Cloudflare.

![Architecture Diagram](docs/images/architecture-diagram.jpg)

## Overview

This project demonstrates the deployment of a containerized Django REST API on AWS using modern DevOps and Cloud Engineering practices.

Infrastructure is provisioned with Terraform, deployments are automated through GitHub Actions, and traffic flows through Cloudflare and an AWS Application Load Balancer to ECS Fargate services running in private subnets.

### Project Goals

- Learn Infrastructure as Code (IaC)
- Implement automated CI/CD pipelines
- Build a cost-efficient cloud environment that can host future projects

---

## Design Decisions

### Why ECS Fargate?

I wanted the benefits of container orchestration without managing EC2 instances.

### Why Terraform?

Terraform allows infrastructure to be:

- Version controlled
- Peer reviewed
- Reproducible across environments

This reduces configuration drift and supports repeatable deployments through CI/CD pipelines.

### Why Cloudflare Instead of Route53 + CloudFront?

The primary motivation was cost efficiency while maintaining ownership of a custom domain for a personal portfolio platform.

Cloudflare provides:

- DNS management
- SSL/TLS certificates
- CDN capabilities
- DDoS protection

This consolidates functionality that would otherwise require multiple AWS services and additional operational costs.

The domain also serves as a foundation for hosting future projects under dedicated subdomains.

### Why Automate DNS Management?

Application Load Balancers receive dynamically generated DNS endpoints whenever infrastructure is recreated.

Without automation, DNS records would need to be updated manually after each deployment.

Using the Cloudflare Terraform provider:

1. Terraform retrieves the newly created ALB endpoint.
2. The corresponding Cloudflare CNAME record is updated automatically.
3. Deployments remain fully reproducible with minimal operational overhead.

## Network Architecture


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


## Challenges & Troubleshooting
---

### Challenge 1: Static Assets Returning 404 Errors

#### Problem

After deploying to ECS Fargate, the Django Admin interface loaded as unstyled HTML. Browser developer tools showed repeated `404 Not Found` errors for CSS and JavaScript assets.

#### Root Cause

The Nginx configuration used the `root` directive:

```nginx
location /static/ {
    root /vol/web/static;
}
```

When a request such as:

```text
/static/admin/css/base.css
```

arrived, Nginx resolved it to:

```text
/vol/web/static/static/admin/css/base.css
```

The duplicated `/static/` directory did not exist, resulting in 404 responses.

#### Resolution

The configuration was updated to use `alias`:

```nginx
location /static/ {
    alias /vol/web/static/;
}
```

Unlike `root`, `alias` replaces the matching URI prefix rather than appending it.

#### Outcome

Static assets were served successfully, restoring application styling and functionality.

> **Lesson Learned:** Understand the difference between Nginx `root` and `alias` directives when serving static content.

---

### Challenge 2: CSRF Verification Failures Behind Cloudflare

#### Problem

After configuring a custom domain through Cloudflare, authenticated Django Admin requests failed with:

```text
403 Forbidden
CSRF verification failed
```

#### Root Cause

Cloudflare was initially configured using **Flexible SSL**:

```text
User
↓
Cloudflare (HTTPS)
↓
ALB (HTTP)
↓
Nginx
↓
Django
```

Because requests traversed multiple proxy layers, Django could not reliably determine the original request protocol and rejected CSRF-protected form submissions.

#### Resolution

- Switched Cloudflare SSL mode from **Flexible** to **Full**
- Forwarded the `X-Forwarded-Proto` header from Nginx
- Configured Django to trust forwarded HTTPS headers
- Added the domain to `CSRF_TRUSTED_ORIGINS`

```python
SECURE_PROXY_SSL_HEADER = (
    "HTTP_X_FORWARDED_PROTO",
    "https"
)

CSRF_TRUSTED_ORIGINS = [
    "https://david-cloud.site",
    "https://*.david-cloud.site",
]
```

#### Outcome

CSRF validation succeeded and authenticated admin functionality was restored.

> **Lesson Learned:** SSL termination and proxy configuration must be considered together when deploying Django behind Cloudflare and load balancers.

---

### Challenge 3: Terraform vs AWS Service-Linked Roles

#### Problem

Terraform deployments and infrastructure destruction intermittently failed with IAM-related errors:

```text
AccessDenied: iam:DeleteServiceLinkedRole
```

```text
Service role name AWSServiceRoleForECS has been taken in this account
```

#### Root Cause

The project attempted to manage the ECS service-linked role:

```terraform
resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}
```

However, `AWSServiceRoleForECS` is automatically managed by AWS.

This caused two issues:

- Terraform attempted to recreate an AWS-managed role.
- The CI/CD IAM user lacked permission to delete it.

#### Resolution

- Removed the service-linked role resource from Terraform
- Removed associated `depends_on` references
- Allowed AWS to manage the role automatically

#### Outcome

Infrastructure deployment and destruction completed successfully without IAM conflicts.

> **Lesson Learned:** Not every cloud resource should be managed through Terraform. AWS-managed service-linked roles should generally remain provider-owned resources.

### Migrating to a Multi-Stage Docker Build

As part of improving the containerization strategy, I refactored the Django application image from a single-stage Alpine-based build to a multi-stage build using Python Slim.

The builder stage contains compilation tooling and development libraries required to install packages such as `psycopg2` and `Pillow`, while the runtime stage contains only the application code, Python environment, and runtime dependencies.

An interesting outcome was that the final image size increased from approximately 60.7 MB to 80.6 MB. This demonstrated that the primary purpose of multi-stage builds is not always image size reduction, but rather improved separation of build and runtime concerns, removal of unnecessary tooling from production containers, and alignment with common production deployment practices.

---

## Future Improvements

Planned enhancements:

- Replace ECS rolling deployments with blue/green deployments
- Add CloudWatch dashboards and alarms
- Introduce centralized logging
- Refactor Terraform configuration into reusable modules
- Introduce environment-based deployment structure
- Add separate dev/stage/prod environments

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

fut

# Multi-Cloud GitOps Application Platform

A production-grade, highly available API platform orchestrating a containerized Django REST application and an Nginx reverse proxy. This ecosystem utilizes an Infrastructure as Code (IaC) methodology to seamlessly link AWS core compute assets with Cloudflare’s global edge networking entirely via automated pipelines.

---

## 🛠️ Technology Stack Matrix

| Layer | Component | Implementation Detail |
| :--- | :--- | :--- |
| **Compute & Orchestration** | AWS ECS (Fargate) | Serverless container execution isolated from host management |
| **Infrastructure Architecture** | Terraform | Immutable state declaration tracking multi-cloud providers |
| **CI/CD Automation Pipeline** | GitHub Actions | GitOps delivery pipelines automating tests, building, and deployment |
| **Edge Network & Security** | Cloudflare | Automated proxy CNAME configuration, CDN caching, and edge SSL/TLS termination |
| **Container Layer** | Docker & Compose | Multi-stage image construction separating code and routing binaries |

---

## 📐 System Architecture Flow

```text
[ Secure Browser Request ] ───────( HTTPS )───────► [ Cloudflare Edge Proxy ]
                                                             │
                                                  ( SSL / TLS Termination )
                                                             │
                                                             ▼
                                               [ AWS Application Load Balancer ]
                                                             │
                                              ( VPC Security Groups Filtering )
                                                             │
                                                             ▼
                                               [ AWS ECS Fargate Task Cluster ]
                                                ├── Container 1: Nginx Proxy (8000)
                                                └── Container 2: Django WSGI App

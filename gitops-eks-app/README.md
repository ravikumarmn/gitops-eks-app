# gitops-eks-app

Application source code repository for a GitOps-managed microservices platform running on Amazon EKS. This repo contains the source code, Dockerfiles, and CI pipelines for each service. It does **not** contain Kubernetes manifests or Helm values — those live in [gitops-eks-config](../gitops-eks-config).

## Architecture Overview

```
                          ┌─────────────────────────────────────────────┐
                          │               Amazon EKS Cluster             │
                          │                                              │
Internet ──► ALB ──► api-gateway ──► auth-service                       │
                          │       └──► product-catalog                   │
                          │       └──► order-service ──► notification-service │
                          └─────────────────────────────────────────────┘
```

Each service is independently deployable. The `api-gateway` is the single entry point; downstream services communicate over internal cluster DNS. Deployments are triggered by image tag updates pushed to `gitops-eks-config` by CI after a successful build.

## Repository Structure

```
gitops-eks-app/
├── api-gateway/          # Reverse proxy / BFF layer
├── auth-service/         # Authentication & authorization (JWT/OAuth2)
├── product-catalog/      # Product inventory and search
├── order-service/        # Order lifecycle management
└── notification-service/ # Email / SMS / push event fan-out
```

## Services

| Service | Port | Responsibility |
|---|---|---|
| `api-gateway` | 8080 | Route, rate-limit, auth-check incoming requests |
| `auth-service` | 8081 | Issue and validate JWTs, manage OAuth2 flows |
| `product-catalog` | 8082 | CRUD for products, categories, search index |
| `order-service` | 8083 | Create/update orders, payment orchestration |
| `notification-service` | 8084 | Consume events, dispatch email/SMS/push |

## GitOps Flow

```
Developer pushes code
        │
        ▼
GitHub Actions CI (per service)
  ├── lint + unit tests
  ├── docker build & push → ECR (tagged with git SHA)
  └── update image tag in gitops-eks-config repo
              │
              ▼
        ArgoCD detects drift
              │
              ▼
        Syncs Helm release to EKS
```

The app repo owns **what** gets built. The config repo owns **where** and **how** it runs.

## CI Pipeline

Each service has an identical pipeline structure at `.github/workflows/ci.yaml` (or `ci/` inside the service folder). The pipeline:

1. Runs on every push to `main` and on pull requests
2. Builds a Docker image tagged `<ECR_REPO>/<service>:<git-sha>`
3. Pushes to Amazon ECR on merges to `main`
4. Opens an automated PR against `gitops-eks-config` to bump the image tag in `environments/dev/values/<service>.yaml`

Promotion from `dev` → `prod` is a manual approval step in `gitops-eks-config`.

## Local Development

### Prerequisites

- Docker & Docker Compose
- `make` (optional, each service has a `Makefile`)

### Run all services locally

```bash
docker compose up --build
```

Each service's `docker-compose.yaml` mounts source files for hot-reload in development mode.

### Run a single service

```bash
cd api-gateway
make dev        # start with live reload
make test       # unit tests
make lint       # linter
make build      # production Docker image
```

## Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Production-ready code; merges trigger a `dev` deploy |
| `feature/*` | Short-lived feature branches, open PRs against `main` |
| `hotfix/*` | Emergency fixes; merged to `main` and cherry-picked if needed |

## Service-Level READMEs

Each subdirectory contains its own `README.md` with:
- Service-specific setup instructions
- Environment variables
- API contract / OpenAPI spec location
- Runbook links

## Related Repositories

- **[gitops-eks-config](../gitops-eks-config)** — Helm charts and environment values; the source of truth for what runs on EKS

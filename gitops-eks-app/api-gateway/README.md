# api-gateway

The single public-facing entry point for the platform. Handles TLS termination (via ALB), request routing to downstream services, rate limiting, and JWT validation.

## Responsibilities

- Route `/auth/*` → `auth-service`
- Route `/products/*` → `product-catalog`
- Route `/orders/*` → `order-service`
- Validate Authorization headers before forwarding
- Emit request-level metrics and structured access logs

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | Listening port (default `8080`) |
| `AUTH_SERVICE_URL` | yes | Internal URL of auth-service |
| `PRODUCT_SERVICE_URL` | yes | Internal URL of product-catalog |
| `ORDER_SERVICE_URL` | yes | Internal URL of order-service |
| `JWT_PUBLIC_KEY` | yes | PEM-encoded public key for JWT verification |
| `RATE_LIMIT_RPS` | no | Per-IP request rate limit (default `100`) |

## Running Locally

```bash
make dev
```

The gateway starts on `http://localhost:8080`. Downstream services must be running (use the root `docker compose up`).

## Health Endpoints

| Path | Description |
|---|---|
| `GET /healthz` | Liveness probe |
| `GET /readyz` | Readiness probe (checks downstream connectivity) |

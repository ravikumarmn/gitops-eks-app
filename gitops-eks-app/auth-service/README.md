# auth-service

Handles user authentication and authorization. Issues short-lived JWTs and refresh tokens, manages OAuth2 social login flows, and exposes a token-introspection endpoint used by the api-gateway.

## Responsibilities

- User registration and login (email/password + social OAuth2)
- JWT issuance (access token: 15 min, refresh token: 7 days)
- Token refresh and revocation
- RBAC role assignment

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | Listening port (default `8081`) |
| `DATABASE_URL` | yes | PostgreSQL connection string |
| `JWT_PRIVATE_KEY` | yes | PEM-encoded private key for signing JWTs |
| `OAUTH2_GOOGLE_CLIENT_ID` | no | Google OAuth2 client ID |
| `OAUTH2_GOOGLE_CLIENT_SECRET` | no | Google OAuth2 client secret |
| `TOKEN_EXPIRY_SECONDS` | no | Access token TTL (default `900`) |

## API

| Method | Path | Description |
|---|---|---|
| `POST` | `/auth/register` | Create account |
| `POST` | `/auth/login` | Email/password login, returns tokens |
| `POST` | `/auth/refresh` | Exchange refresh token for new access token |
| `POST` | `/auth/logout` | Revoke refresh token |
| `GET` | `/auth/introspect` | Validate token (used by api-gateway) |

Full OpenAPI spec: `openapi.yaml` in this directory.

## Running Locally

```bash
make dev   # requires a local Postgres instance
```

Migrate the database first:

```bash
make migrate
```

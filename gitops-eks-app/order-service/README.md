# order-service

Manages the full order lifecycle: cart → checkout → payment → fulfillment → cancellation. Coordinates with product-catalog (stock reservation) and publishes `order.*` events for notification-service to fan out.

## Responsibilities

- Cart management and checkout flow
- Payment orchestration (Stripe integration)
- Stock reservation via product-catalog API
- Order state machine: `PENDING → CONFIRMED → SHIPPED → DELIVERED | CANCELLED`
- Publish `order.created`, `order.shipped`, `order.cancelled` events

## Order State Machine

```
PENDING ──► CONFIRMED ──► SHIPPED ──► DELIVERED
    │            │
    └────────────┴──► CANCELLED
```

Transitions are persisted transactionally; events are published after commit.

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | Listening port (default `8083`) |
| `DATABASE_URL` | yes | PostgreSQL connection string |
| `PRODUCT_SERVICE_URL` | yes | Internal URL of product-catalog |
| `STRIPE_SECRET_KEY` | yes | Stripe API secret |
| `KAFKA_BROKERS` | yes | Comma-separated Kafka broker addresses |
| `KAFKA_TOPIC_ORDER` | no | Topic for order events (default `order.events`) |

## API

| Method | Path | Description |
|---|---|---|
| `POST` | `/orders` | Create order from cart |
| `GET` | `/orders/:id` | Get order details |
| `GET` | `/orders` | List orders for authenticated user |
| `POST` | `/orders/:id/cancel` | Cancel an order |

## Running Locally

```bash
make dev
```

Set `STRIPE_SECRET_KEY` to a Stripe test key. Use the root `docker-compose.yaml` for Postgres and Kafka.

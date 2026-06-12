# product-catalog

Manages the product inventory: creation, updates, soft-deletes, category taxonomy, and full-text search. Publishes `product.updated` events to the message bus consumed by order-service and notification-service.

## Responsibilities

- CRUD for products and categories
- Full-text and faceted search (backed by OpenSearch)
- Inventory stock level tracking
- Publish domain events on product changes

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | Listening port (default `8082`) |
| `DATABASE_URL` | yes | PostgreSQL connection string |
| `OPENSEARCH_URL` | yes | OpenSearch cluster endpoint |
| `KAFKA_BROKERS` | yes | Comma-separated Kafka broker addresses |
| `KAFKA_TOPIC_PRODUCT` | no | Topic for product events (default `product.events`) |

## API

| Method | Path | Description |
|---|---|---|
| `GET` | `/products` | List products (paginated, filterable) |
| `GET` | `/products/:id` | Get single product |
| `POST` | `/products` | Create product (admin only) |
| `PUT` | `/products/:id` | Update product (admin only) |
| `DELETE` | `/products/:id` | Soft-delete product (admin only) |
| `GET` | `/products/search` | Full-text search |

## Running Locally

```bash
make dev
```

Requires local Postgres, OpenSearch, and Kafka. Use the root `docker-compose.yaml` to spin up dependencies.

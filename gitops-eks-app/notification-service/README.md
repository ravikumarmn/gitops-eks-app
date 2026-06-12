# notification-service

Stateless event consumer that fans out notifications across channels (email, SMS, push) in response to domain events from order-service and auth-service. All delivery logic is idempotent — retries are safe.

## Responsibilities

- Consume `order.created`, `order.shipped`, `order.cancelled` from Kafka
- Consume `auth.password_reset` events
- Render templated messages (email via SES, SMS via SNS, push via FCM)
- Track delivery status and expose a status API

## Supported Channels

| Channel | Provider |
|---|---|
| Email | Amazon SES |
| SMS | Amazon SNS |
| Push (mobile) | Firebase Cloud Messaging (FCM) |

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `PORT` | no | Listening port (default `8084`) |
| `KAFKA_BROKERS` | yes | Comma-separated Kafka broker addresses |
| `KAFKA_GROUP_ID` | no | Consumer group ID (default `notification-service`) |
| `AWS_REGION` | yes | AWS region for SES/SNS |
| `SES_FROM_ADDRESS` | yes | Verified sender email address |
| `FCM_SERVER_KEY` | no | Firebase server key for push notifications |
| `DATABASE_URL` | yes | PostgreSQL for delivery status tracking |

## Event Subscriptions

| Kafka Topic | Event | Action |
|---|---|---|
| `order.events` | `order.created` | Send order confirmation email + push |
| `order.events` | `order.shipped` | Send shipping notification with tracking link |
| `order.events` | `order.cancelled` | Send cancellation confirmation email |
| `auth.events` | `auth.password_reset` | Send password reset email |

## Running Locally

```bash
make dev
```

AWS credentials must be configured for SES/SNS. Use localstack for fully offline development:

```bash
docker compose --profile localstack up
```

const express = require('express');

const app = express();
app.use(express.json());

const port = process.env.PORT || 3004;

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'notification-service' });
});

app.post('/notify', (req, res) => {
  const { event, order_id, message } = req.body || {};

  if (!event) {
    return res.status(400).json({ error: 'event required' });
  }

  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    event,
    order_id: order_id || null,
    message: message || `Event received: ${event}`,
  }));

  res.json({ status: 'notified', event });
});

app.listen(port, () => {
  console.log(`Notification Service listening on port ${port}`);
});

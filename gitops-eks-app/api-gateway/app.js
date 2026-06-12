const express = require('express');
const httpProxy = require('http-proxy');

const app = express();
const port = process.env.PORT || 3000;

const authServiceUrl = process.env.AUTH_SERVICE_URL || 'http://localhost:3001';
const productServiceUrl = process.env.PRODUCT_SERVICE_URL || 'http://localhost:3002';
const orderServiceUrl = process.env.ORDER_SERVICE_URL || 'http://localhost:3003';

// Create proxy instances
const authProxy = httpProxy.createProxyServer({ target: authServiceUrl });
const productProxy = httpProxy.createProxyServer({ target: productServiceUrl });
const orderProxy = httpProxy.createProxyServer({ target: orderServiceUrl });

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'api-gateway' });
});

// Proxy routes
app.use('/auth', (req, res) => {
  authProxy.web(req, res);
});

app.use('/products', (req, res) => {
  productProxy.web(req, res);
});

app.use('/orders', (req, res) => {
  orderProxy.web(req, res);
});

// Handle proxy errors
[authProxy, productProxy, orderProxy].forEach(proxy => {
  proxy.on('error', (err, req, res) => {
    console.error('Proxy error:', err.message);
    res.status(503).json({ error: 'Service unavailable' });
  });
});

app.listen(port, () => {
  console.log(`API Gateway listening on port ${port}`);
  console.log(`Auth Service: ${authServiceUrl}`);
  console.log(`Product Service: ${productServiceUrl}`);
  console.log(`Order Service: ${orderServiceUrl}`);
});

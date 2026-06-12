const express = require('express');

const app = express();
app.use(express.json());

const port = process.env.PORT || 3002;

const products = [
  { id: '1', name: 'Laptop', price: 999.99, stock: 50 },
  { id: '2', name: 'Mouse', price: 29.99, stock: 200 },
  { id: '3', name: 'Keyboard', price: 79.99, stock: 150 },
];

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'product-catalog' });
});

app.get('/products', (req, res) => {
  res.json(products);
});

app.get('/products/:id', (req, res) => {
  const product = products.find(p => p.id === req.params.id);
  if (!product) return res.status(404).json({ error: 'product not found' });
  res.json(product);
});

app.post('/products', (req, res) => {
  const { name, price, stock } = req.body;
  if (!name || price == null) {
    return res.status(400).json({ error: 'name and price required' });
  }
  const product = { id: String(products.length + 1), name, price, stock: stock || 0 };
  products.push(product);
  res.status(201).json(product);
});

app.listen(port, () => {
  console.log(`Product Catalog listening on port ${port}`);
});

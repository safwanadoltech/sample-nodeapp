const express = require('express');
const app = express();
const port = 3000; // You can change the port to any port you prefer

app.get('/', (req, res) => {
  res.send('Hello, world');
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
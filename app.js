const express = require('express');
const app = express();
const port = 3000; // You can change the port as needed

// Define a route that responds with "Hello, World!"
app.get('/', (req, res) => {
  res.send('Hello from the other side');
});

// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


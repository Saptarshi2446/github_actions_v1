// const express = require('express')

// const app = express()



// app.get('/', (req, res) => {
//     res.json({
//         status: 200,
//         message: "hello world changing"
//     })
// })

// app.listen(8080, () => {
//     console.log('server running on port 8080')
// })

const express = require('express');
const os = require('os');

const app = express();

// Use environment variable PORT if set, otherwise default to 8083
const PORT = process.env.PORT || 8081;

const messages = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.",
  "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.",
  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia."
];

// Root API
app.get('/', (req, res) => {
  res.json({
    status: 200,
    clientIp: req.ip || req.connection.remoteAddress,
    timestamp: new Date().toISOString(),
    messages: messages
  });
});

// Status API
app.get('/status', (req, res) => {
  res.json({
    status: "OK",
    uptime: process.uptime().toFixed(2) + " seconds",
    server: os.hostname(),
    platform: os.platform()
  });
});

// Info API
app.get('/info', (req, res) => {
  const randomMsg = messages[Math.floor(Math.random() * messages.length)];
  res.json({
    status: 200,
    messageOfTheDay: randomMsg,
    serverTime: new Date().toLocaleString(),
    clientIp: req.ip
  });
});

// Dashboard (HTML view)
app.get('/dashboard', (req, res) => {
  const randomMsg = messages[Math.floor(Math.random() * messages.length)];
  const clientIp = req.ip || req.connection.remoteAddress;
  const uptime = process.uptime().toFixed(2);

  res.send(`
    <html>
      <head>
        <title>Mini Dashboard</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
          .card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0px 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
          h1 { color: #007bff; }
          .value { font-size: 1.2em; color: #333; }
        </style>
      </head>
      <body>
        <h1>🚀 Mini Server Dashboard</h1>
        <div class="card">
          <h2>Status</h2>
          <p class="value">OK</p>
        </div>
        <div class="card">
          <h2>Server Info</h2>
          <p class="value">Hostname: ${os.hostname()}</p>
          <p class="value">Platform: ${os.platform()}</p>
          <p class="value">Uptime: ${uptime} seconds</p>
        </div>
        <div class="card">
          <h2>Client Info</h2>
          <p class="value">Your IP: ${clientIp}</p>
          <p class="value">Time: ${new Date().toLocaleString()}</p>
        </div>
        <div class="card">
          <h2>Message of the Day</h2>
          <p class="value">${randomMsg}</p>
        </div>
      </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

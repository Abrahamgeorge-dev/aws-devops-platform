const express = require("express");

const app = express();

const PORT = process.env.PORT || 3000;

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok"
  });
});

app.get("/", (req, res) => {
  res.json({
    message: "AWS DevOps Platform is running"
  });
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Application running on port ${PORT}`);
  });
}

module.exports = app;

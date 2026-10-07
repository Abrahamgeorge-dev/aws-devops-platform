const request = require("supertest");
const app = require("../src/server");

describe("Health Check", () => {
  test("GET /health should return status 200 and ok", async () => {
    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe("ok");
  });
});

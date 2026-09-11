# Personal Money Tracker API

Production-ready REST API backend for the Personal Money Tracker application. Built with Node.js, Express, TypeScript, and MySQL 8.

---

## Features

- **Authentication & Security:** Argon2 password hashing, short-lived JWT access tokens with refresh tokens, Helmet security headers, and rate limiting.
- **Financial Integrity:** Precise Decimal.js calculations, database-level invariants, account isolation, and transfer logs.
- **Production Ready:** Multi-stage Dockerfile, Docker Compose stack with automated MySQL initialization and migrations, PM2 clustering, and Nginx reverse proxy configuration.
- **Health & Monitoring:** `/health` endpoint for uptime monitoring and Docker healthchecks, structured Pino JSON logging.

---

## Quick Start (Docker Compose - Recommended)

1. **Clone repository:**
   ```bash
   git clone https://github.com/tarek9909/money_transfer.git backend-api
   cd backend-api
   ```

2. **Configure environment:**
   ```bash
   cp .env.production.example .env
   # Edit .env and set strong passwords and JWT secret
   nano .env
   ```

3. **Start services:**
   ```bash
   docker compose up -d
   ```

4. **Verify:**
   ```bash
   curl http://localhost:3000/health
   # Returns: {"status":"ok"}
   ```

---

## Local Development (Without Docker)

1. **Install MySQL 8+ locally.**
2. **Create the database and user:**
   ```sql
   CREATE DATABASE IF NOT EXISTS personal_money_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER IF NOT EXISTS 'money_tracker'@'127.0.0.1' IDENTIFIED BY 'change-me';
   GRANT ALL PRIVILEGES ON personal_money_tracker.* TO 'money_tracker'@'127.0.0.1';
   ```
3. **Configure `.env`:**
   ```bash
   cp .env.example .env
   ```
4. **Initialize development database:**
   ```bash
   mysql -u root -p -e "source DB.SQL"
   ```
5. **Install dependencies and run migrations:**
   ```bash
   npm install
   npm run migrate
   ```
6. **Start dev server:**
   ```bash
   npm run dev
   ```

---

## Production Deployment

For detailed server deployment instructions (Ubuntu VPS, Docker, PM2, Systemd, Nginx, SSL certificates, and Flutter client connection), see [SERVER_DEPLOYMENT.md](SERVER_DEPLOYMENT.md).

---

## API Specification

- Base URL: `/api/v1`
- Standard Success Envelope: `{ "success": true, "data": { ... } }`
- Standard Error Envelope: `{ "success": false, "message": "...", "code": "..." }`
- Health Probe: `GET /health` (returns `{ "status": "ok" }`)

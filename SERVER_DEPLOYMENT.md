# Server Deployment Guide - Personal Money Tracker API

This guide provides instructions for deploying the Personal Money Tracker backend API on a remote Linux server (Ubuntu 22.04 / 24.04 LTS, Debian, or any cloud VPS such as AWS EC2, DigitalOcean, Hetzner, Linode, etc.).

---

## Architecture Overview

* **Runtime:** Node.js (v20+ or v22 LTS)
* **Framework:** Express + TypeScript
* **Database:** MySQL 8.0+
* **Port:** `3000` (can be proxied via Nginx or exposed directly)
* **Health Check:** `GET /health` returns `{ "status": "ok" }`

---

## Method 1: Docker Compose (Recommended - Fastest & Easiest)

Docker Compose provisions both the Node.js API and MySQL database in isolated containers with automatic restart, healthchecks, and volume persistence.

### 1. Prerequisites on the Server
Install Docker and Docker Compose plugin on Ubuntu/Debian:
```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2. Clone the Repository on the Server
```bash
git clone https://github.com/tarek9909/money_transfer.git backend-api
cd backend-api
```

### 3. Configure Environment Variables
Copy `.env.production.example` to `.env`:
```bash
cp .env.production.example .env
```
Edit `.env` using `nano .env`:
```bash
nano .env
```
Make sure to:
1. Generate a strong 32+ character JWT secret:
   ```bash
   openssl rand -base64 32
   ```
   Paste this into `JWT_ACCESS_SECRET`.
2. Set strong passwords for `DATABASE_PASSWORD` and `DATABASE_ROOT_PASSWORD`.
3. Set `CORS_ORIGINS=*` (or your frontend origin).

### 4. Start the Application
```bash
docker compose up -d
```

### 5. Verify the Service
Check container status:
```bash
docker compose ps
```
Test the healthcheck endpoint:
```bash
curl http://localhost:3000/health
# Output: {"status":"ok"}
```
View live logs:
```bash
docker compose logs -f api
```

To update in the future:
```bash
git pull
docker compose build --no-cache api
docker compose up -d
```

---

## Method 2: Native Bare-Metal Setup (Node.js + PM2 + MySQL + Nginx)

If you prefer running services directly on the host without Docker:

### 1. Install Node.js 22 LTS, MySQL 8, and PM2
```bash
# Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs mysql-server nginx

# Install PM2 globally
sudo npm install -g pm2
```

### 2. Configure MySQL Database
Access MySQL:
```bash
sudo mysql
```
Run the setup commands:
```sql
CREATE DATABASE IF NOT EXISTS personal_money_tracker CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'money_tracker'@'127.0.0.1' IDENTIFIED BY 'YOUR_STRONG_PASSWORD';
GRANT ALL PRIVILEGES ON personal_money_tracker.* TO 'money_tracker'@'127.0.0.1';
FLUSH PRIVILEGES;
EXIT;
```

Load the initial schema:
```bash
mysql -u money_tracker -p personal_money_tracker < DB.SQL
```

### 3. Install & Build the API
```bash
cp .env.production.example .env
nano .env # Set DATABASE_PASSWORD and JWT_ACCESS_SECRET

npm ci
npm run build
npm run migrate:prod
```

### 4. Run with PM2
```bash
pm2 start ecosystem.config.cjs --env production
pm2 save
pm2 startup
```

### 5. Configure Nginx Reverse Proxy (Optional Domain & SSL)
```bash
sudo cp nginx.conf /etc/nginx/sites-available/money-tracker
sudo nano /etc/nginx/sites-available/money-tracker # Set your domain name
sudo ln -s /etc/nginx/sites-available/money-tracker /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```
To enable HTTPS with Let's Encrypt:
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

---

## Connecting the Flutter Mobile App

1. Once your server is running, note your server's Public IP or Domain:
   - Example: `http://123.45.67.89:3000/api/v1`
   - Or with domain & HTTPS: `https://api.yourdomain.com/api/v1`
2. Open the Flutter app on your phone.
3. In the Settings or Login screen:
   - Tap the server configuration / URL field.
   - Enter your server address: `http://<YOUR_SERVER_IP>:3000/api/v1` (or `https://...`).
   - Tap **Save & Test Connection**.
   - You should see "Connection successful"!

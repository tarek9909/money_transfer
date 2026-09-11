#!/usr/bin/env bash
set -e

echo "=== Deploying Personal Money Tracker API ==="

# Check if .env exists
if [ ! -f .env ]; then
  echo "Error: .env file not found! Copy .env.production.example to .env and configure it first."
  exit 1
fi

if [ -f docker-compose.yml ] && command -v docker &> /dev/null && docker compose version &> /dev/null; then
  echo "--> Deploying with Docker Compose..."
  docker compose pull || true
  docker compose build --no-cache api
  docker compose up -d
  echo "--> Waiting for services to initialize..."
  docker compose ps
  echo "=== Docker Deployment Complete ==="
  exit 0
fi

echo "--> Deploying natively (PM2 / Node.js)..."
echo "1. Installing dependencies..."
npm ci --include=dev

echo "2. Building TypeScript..."
npm run build

echo "3. Pruning dev dependencies..."
npm prune --production

echo "4. Running database migrations..."
npm run migrate:prod

if command -v pm2 &> /dev/null; then
  echo "5. Reloading PM2 process..."
  pm2 reload ecosystem.config.cjs --env production || pm2 start ecosystem.config.cjs --env production
  pm2 save
fi

echo "=== Native Deployment Complete ==="

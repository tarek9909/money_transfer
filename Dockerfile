# Multi-stage Dockerfile for Personal Money Tracker API

# Stage 1: Build
FROM node:22-bookworm-slim AS builder

WORKDIR /app

# Copy package manifests and tsconfig
COPY package*.json tsconfig.json ./

# Install dependencies (including devDependencies for TypeScript build)
RUN npm ci

# Copy source code and scripts
COPY src/ ./src/
COPY scripts/ ./scripts/

# Build TypeScript to dist/
RUN npm run build

# Stage 2: Production Runner
FROM node:22-bookworm-slim AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Install curl for healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency definitions
COPY package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev && npm cache clean --force

# Copy compiled JavaScript from builder
COPY --from=builder /app/dist ./dist

# Copy migrations, scripts, and initial DB schema
COPY migrations/ ./migrations/
COPY DB.SQL ./

# Run as non-privileged user for security
USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["sh", "-c", "node dist/scripts/migrate.js && node dist/src/server.js"]

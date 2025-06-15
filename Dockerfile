# -------- Stage 1: Build --------
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first for better layer caching
COPY app/package*.json ./
RUN npm ci

# Copy all other necessary files
COPY app/tsconfig.json .
COPY app/src ./src
COPY app/config ./config

# Build the application
RUN npm run build

# -------- Stage 2: Runtime --------
FROM gcr.io/distroless/nodejs:18

WORKDIR /app

# Copy only what's needed for production
COPY --chown=nonroot:nonroot --from=builder /app/dist ./dist
COPY --chown=nonroot:nonroot --from=builder /app/node_modules ./node_modules
COPY --chown=nonroot:nonroot --from=builder /app/config ./config

USER nonroot
EXPOSE 9002

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:9002/healthz || exit 1

CMD ["dist/index.js"]

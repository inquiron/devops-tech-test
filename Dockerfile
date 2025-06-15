# -------- Build Stage --------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files to install deps with caching
COPY app/package.json .
COPY app/package-lock.json .

# Install deps
RUN npm ci

# Copy remaining app source code including tsconfig and config dir
COPY app/tsconfig.json ./
COPY app/config ./config
COPY app/ ./

# Compile TypeScript
RUN npm run compile

# -------- Runtime Stage --------
FROM node:18-alpine

# Add tini for proper signal handling
RUN apk add --no-cache tini

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy necessary artifacts from builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/config ./config

# Set ownership to non-root user
RUN chown -R appuser:appgroup /app

# Use non-root user
USER appuser

# Set environment variable (can be overridden)
ENV APP_PORT=9002

# Expose app port
EXPOSE 9002

# Use Tini for graceful shutdown and run app
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]

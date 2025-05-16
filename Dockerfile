# -------- Stage 1: Build Stage --------
FROM node:21.6.0-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install all dependencies (including dev)
COPY app/package*.json ./
RUN npm install

# Copy the entire source code and build the project
COPY app/ .
RUN npm run compile


# -------- Stage 2: Production Stage --------
FROM node:21.6.0-alpine

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy only package files and install production dependencies
COPY app/package*.json ./
RUN npm install --omit=dev

# Copy compiled app and config from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config

# Set correct permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 9002

# Set the entrypoint and cmd
ENTRYPOINT ["node"]
CMD ["dist/index.js"]

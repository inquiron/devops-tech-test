# Build Stage
FROM node:21.6.0-alpine AS builder

# Define working directory for app source
WORKDIR /app

# Copying package files and install all dependencies
COPY app/package*.json ./
RUN npm install

# Copy source files and build the app
COPY app/ .
RUN npm run compile


# Runtime Stage
FROM node:21.6.0-alpine AS runtime

# Set secure runtime environment
ENV NODE_ENV=production \
    APP_PORT=9002 \
    CONFIG_PATH=./config

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy only package files and install production dependencies
COPY app/package*.json ./
RUN npm install --omit=dev

# Copying compiled app and config from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config

# Set ownership & permissions
RUN chown -R appuser:appgroup /app
USER appuser

# Expose the application port
EXPOSE ${APP_PORT}

# Set the entrypoint and cmd
ENTRYPOINT ["node"]
CMD ["dist/index.js"]

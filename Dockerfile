# Build Stage
FROM node:21.6.0-alpine AS builder

# Define working directory for app source
WORKDIR /app

# Copying package files and install all dependencies
COPY app/package*.json ./
RUN npm install

# Copy the entire source code and build the project
COPY app/ .

# Compile the application
RUN npm run compile


# Production Stage
FROM node:21.6.0-alpine AS runtime

# Create non-root user for security
RUN addgroup -S prodgroup && produser -S produser -G prodgroup

# Set working directory
WORKDIR /app

# Copy only package files and install production dependencies
COPY app/package*.json ./
RUN npm install --omit=dev

# Copying compiled app and config from builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/config ./config

# Define correct permissions
RUN chown -R produser:prodgroup /app

# Switch to non-root user
USER produser

# Expose the application port
EXPOSE 9002

# Set the entrypoint and cmd
ENTRYPOINT ["node"]
CMD ["dist/index.js"]

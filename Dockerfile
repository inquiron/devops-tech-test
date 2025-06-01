FROM node:22.16.0-alpine3.21

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm i

# Build app
COPY ./ ./ 
RUN npm run compile



FROM node:22.16.0-alpine3.21

WORKDIR /app

# Install runtime dependencies
COPY package.json package-lock.json ./
RUN npm i --omit dev

# Copy built app
COPY --from=0 /app/dist/ /app/dist/
COPY config/ config/

# Setup user for run
RUN adduser -S appUser
USER appUser

EXPOSE 9002

ENTRYPOINT ["node", "dist/index.js"]
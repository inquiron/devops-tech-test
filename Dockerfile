FROM node:22-bullseye-slim

# Copy app source code and exposing port
RUN mkdir app
WORKDIR /app

COPY package.json package-lock.json .
RUN npm i

COPY . . 
RUN npm run compile

# Setup a user 'app' to avoid running on root
RUN useradd app
USER app

EXPOSE 9002

ENTRYPOINT ["node", "dist/index.js"]
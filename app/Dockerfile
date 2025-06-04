FROM node:22

COPY package.json .

RUN npm install

COPY ./ ./

RUN npm run compile

CMD ["node", "dist/index.js"]
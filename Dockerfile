FROM node:18.20-alpine

WORKDIR /usr/src/app

#Install git
RUN apk add --no-cache git

COPY src/package*.json ./
RUN npm install

COPY src/index.js .

EXPOSE 8090

CMD [ "node", "index.js" ]

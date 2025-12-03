FROM node:16-alpine

WORKDIR /app

RUN apk update && apk add --no-cache curl

COPY package*.json ./

RUN npm install --only=production

COPY . .

RUN mkdir -p public/uploads/admin

EXPOSE 8888

CMD ["npm", "start"]
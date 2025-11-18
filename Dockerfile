FROM node:16-alpine

# Install netcat for checking database connectivity
RUN apk add --no-cache netcat-openbsd

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Create necessary directories
RUN mkdir -p public/uploads/admin

# Create .variables.env from template if it doesn't exist
RUN if [ ! -f .variables.env ]; then cp .variables.env.tmp .variables.env; fi

# Copy entrypoint script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Expose port
EXPOSE 8888

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["npm", "start"]

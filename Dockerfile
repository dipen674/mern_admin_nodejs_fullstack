FROM node:16-alpine

# Set working directory inside container
WORKDIR /app

RUN apk update \
    && apk add --no-cache curl

# Copy package files first (optimizes Docker layer caching)
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy application source code (includes .variables.env)
COPY . .

# Create necessary directories for file uploads
RUN mkdir -p public/uploads/admin

# Expose application port
EXPOSE 8888

# Start the application
CMD ["npm", "start"]

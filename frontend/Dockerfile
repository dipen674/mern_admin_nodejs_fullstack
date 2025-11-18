FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code (includes .env file)
COPY . .

# Expose development server port
EXPOSE 3000

# Start React development server
CMD ["npm", "start"]

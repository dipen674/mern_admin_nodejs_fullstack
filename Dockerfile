FROM node:16-alpine

WORKDIR /app

# Install curl (useful for healthchecks, keeps image small)
RUN apk update && apk add --no-cache curl

# Copy package files
COPY package*.json ./

# Install ONLY production dependencies
# (Skips devDependencies like nodemon, eslint, etc.)
RUN npm install --only=production

# Copy application source code 
# (The .dockerignore we made in Step 1 prevents frontend/ being copied here)
COPY . .

# Create necessary directories for file uploads
RUN mkdir -p public/uploads/admin

# Expose application port
EXPOSE 8888

# Start the application
CMD ["npm", "start"]
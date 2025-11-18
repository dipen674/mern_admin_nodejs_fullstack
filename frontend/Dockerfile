FROM node:16-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code and environment files
COPY . .

# Create .env if it doesn't exist
RUN if [ ! -f .env ]; then \
      echo "REACT_APP_API_BASE_URL=http://localhost:8888/api/" > .env && \
      echo "GENERATE_SOURCEMAP=false" >> .env; \
    fi

# Expose port
EXPOSE 3000

CMD ["npm", "start"]

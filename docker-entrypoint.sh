#!/bin/sh
set -e

echo "Waiting for MongoDB to be ready..."

# Wait for MongoDB to be available
until nc -z mongodb 27017; do
  echo "MongoDB is unavailable - sleeping"
  sleep 2
done

echo "MongoDB is up - running setup"

# Run the setup
npm run setup

# Start the application
exec "$@"

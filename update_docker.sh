#!/bin/bash

echo "🔄 Updating Docker containers..."

# Stop and remove existing containers
echo "⏹️  Stopping containers..."
docker-compose down

# Rebuild images
echo "🔨 Rebuilding images..."
docker-compose build --no-cache

# Start containers
echo "🚀 Starting containers..."
docker-compose up -d

echo "✅ Update complete!"
docker-compose ps

#!/bin/bash

# Simple startup script for the streaming stack

echo "🚀 Starting Simple Data Engineering Streaming Docker Stack"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Create data directories if they don't exist
echo ""
echo "📁 Creating data directories..."
mkdir -p ../data/{kafka,zookeeper/data,zookeeper/logs,postgres,grafana,prometheus}
echo "✅ Data directories created"

# Start the stack
echo ""
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Wait a moment for containers to start
echo ""
echo "⏳ Waiting for services to start..."
sleep 5

# Show status
echo ""
echo "📊 Container Status:"
docker-compose ps

echo ""
echo "🎉 Stack is starting up!"
echo ""
echo "Access your services at:"
echo "  - Traefik Dashboard: http://localhost:8080"
echo "  - Grafana: http://grafana.localhost (admin/admin)"
echo "  - Prometheus: http://prometheus.localhost"
echo "  - PostgreSQL: localhost:5432 (postgres/postgres)"
echo "  - Kafka: localhost:9092"
echo ""
echo "📝 View logs with: docker-compose logs -f"
echo "🛑 Stop with: docker-compose down"
echo ""
echo "For detailed usage instructions, see README.md"


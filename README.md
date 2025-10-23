# Simple Data Engineering Streaming Docker Stack

A complete Docker stack for learning data streaming with Kafka, PostgreSQL, Grafana, Prometheus, and Traefik.

## 🛠 Components

- **Apache Kafka** (port 9092) - Distributed streaming platform
- **Zookeeper** (port 2181) - Kafka coordination service
- **PostgreSQL** (port 5432) - Relational database
- **Grafana** (http://grafana.localhost) - Data visualization
- **Prometheus** (http://prometheus.localhost) - Metrics collection
- **Traefik** (port 8080, dashboard on port 8081) - Reverse proxy

## 📋 Prerequisites

- Docker Desktop or Docker Engine (20.10+)
- Docker Compose (v2.0+)
- At least 4GB of RAM available for Docker
- Ports 80, 5432, 8080, 9092 available

## 🚀 Quick Start

### 1. Setup Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit .env if you want to change default credentials
```

### 2. Start the Stack

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 3. Access Services

Once all containers are running, you can access:

- **Traefik Dashboard**: http://localhost:8080
- **Grafana**: http://grafana.localhost (admin/admin)
- **Prometheus**: http://prometheus.localhost
- **PostgreSQL**: localhost:5432 (postgres/postgres)
- **Kafka**: localhost:9092

> **Note**: For `*.localhost` domains to work, you may need to add entries to your `/etc/hosts` file on some systems:
> ```
> 127.0.0.1 grafana.localhost
> 127.0.0.1 prometheus.localhost
> 127.0.0.1 traefik.localhost
> ```

## 📊 Common Operations

### Working with Kafka

```bash
# Create a topic
docker exec -it kafka kafka-topics --create \
  --topic test-topic \
  --bootstrap-server localhost:9092 \
  --partitions 3 \
  --replication-factor 1

# List topics
docker exec -it kafka kafka-topics --list \
  --bootstrap-server localhost:9092

# Produce messages
docker exec -it kafka kafka-console-producer \
  --topic test-topic \
  --bootstrap-server localhost:9092

# Consume messages
docker exec -it kafka kafka-console-consumer \
  --topic test-topic \
  --bootstrap-server localhost:9092 \
  --from-beginning
```

### Working with PostgreSQL

```bash
# Connect to PostgreSQL
docker exec -it postgres psql -U postgres -d streaming_db

# Or using psql from your host (if installed)
psql -h localhost -U postgres -d streaming_db
```

### Viewing Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f kafka
docker-compose logs -f postgres
```

## 🎓 Learning Resources

### Setting up Grafana

1. Login to Grafana at http://grafana.localhost (admin/admin)
2. Add Prometheus as a data source:
   - Go to Configuration → Data Sources
   - Click "Add data source"
   - Select "Prometheus"
   - URL: `http://prometheus:9090`
   - Click "Save & Test"

### Sample Python Producer

Here's a simple Python example to produce messages to Kafka:

```python
from kafka import KafkaProducer
import json
import time

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Send messages
for i in range(100):
    data = {'id': i, 'value': f'message-{i}'}
    producer.send('test-topic', data)
    print(f"Sent: {data}")
    time.sleep(1)

producer.close()
```

### Sample Python Consumer

```python
from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'test-topic',
    bootstrap_servers=['localhost:9092'],
    auto_offset_reset='earliest',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    print(f"Received: {message.value}")
```

## 🗂 Data Persistence

All data is stored in `../data/` directory:

```
../data/
├── kafka/          # Kafka data
├── zookeeper/      # Zookeeper data
├── postgres/       # PostgreSQL data
├── grafana/        # Grafana dashboards and settings
└── prometheus/     # Prometheus metrics data
```

## 🔧 Management Commands

```bash
# Stop all services
docker-compose stop

# Stop and remove containers (data persists)
docker-compose down

# Stop, remove containers and volumes (DELETES ALL DATA!)
docker-compose down -v

# Restart a specific service
docker-compose restart kafka

# View resource usage
docker stats

# Pull latest images
docker-compose pull
```

## 🐛 Troubleshooting

### Kafka not connecting

- Ensure Zookeeper is running: `docker-compose logs zookeeper`
- Check Kafka logs: `docker-compose logs kafka`
- Verify Kafka is listening: `docker exec -it kafka nc -zv localhost 9092`

### PostgreSQL connection issues

- Check if container is healthy: `docker-compose ps postgres`
- View logs: `docker-compose logs postgres`
- Test connection: `docker exec -it postgres pg_isready -U postgres`

### Port conflicts

If you get port binding errors:
```bash
# Check what's using the port (example for port 9092)
lsof -i :9092

# Stop the service or change the port in docker-compose.yml
```

### Reset everything

```bash
# Stop and remove everything including volumes
docker-compose down -v

# Remove data directory
rm -rf ../data

# Start fresh
docker-compose up -d
```

## 📚 Next Steps

1. **Create a data pipeline**: Write a producer that fetches data from an API
2. **Store in PostgreSQL**: Create a consumer that writes to PostgreSQL
3. **Visualize in Grafana**: Create dashboards to monitor your pipeline
4. **Add monitoring**: Instrument your code with Prometheus metrics
5. **Experiment with Kafka**: Try different partition strategies, consumer groups

## 🔒 Security Note

**This stack is configured for local development and learning only.**

For production use, you should:
- Change all default passwords
- Enable SSL/TLS encryption
- Implement proper authentication
- Use secrets management
- Configure proper network isolation
- Set up backup strategies

## 📝 License

This is a learning project. Use it however you like!

## 🤝 Contributing

Feel free to customize this stack for your learning needs. Some ideas:
- Add Redis for caching
- Add Kafka Connect for easy integrations
- Add Schema Registry for Avro schemas
- Add custom dashboards for Grafana

Happy streaming! 🚀


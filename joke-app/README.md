# Joke App

A simple application with a backend REST API and frontend web interface, designed for Kubernetes.

## Architecture

- **Backend**: Express.js on port 3000, connects to PostgreSQL
- **Frontend**: Express.js on port 8080, proxies `/api/joke` requests to backend
- **Database**: PostgreSQL with `jokes` table

## Environment Variables

### Backend
| Variable | Default | Description |
|----------|---------|-------------|
| DB_HOST | localhost | PostgreSQL host |
| DB_PORT | 5432 | PostgreSQL port |
| DB_NAME | jokes | Database name |
| DB_USER | postgres | Database user |
| DB_PASSWORD | postgres | Database password |

### Frontend
| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 8080 | Server port |
| BACKEND_URL | http://localhost:3000 | Backend API URL |

## Local Development

### Database
```bash
createdb jokes
psql -d jokes -f backend/schema.sql
```

### Backend
```bash
cd backend
npm install
npm start
```

### Frontend
```bash
cd frontend
npm install
npm start
```

## Kubernetes Deployment

### Prerequisites
- Kubernetes cluster
- PostgreSQL instance (or use the `postgres` manifests)
- Docker for building images

### Build Images
```bash
docker build -t joke-backend:latest ./backend
docker build -t joke-frontend:latest ./frontend
```

### Apply Manifests
```bash
kubectl apply -f k8s/backend-ns.yaml
kubectl apply -f k8s/frontend-ns.yaml
```

Or without namespace:
```bash
kubectl apply -f k8s/backend.yaml
kubectl apply -f k8s/frontend.yaml
```

### Update Secrets
```bash
kubectl create secret generic joke-backend-secret --from-literal=db-password=YOUR_PASSWORD
```

## API Endpoints

- `GET /api/joke` - Returns a random joke
- `GET /api/jokes` - Returns all jokes
- `GET /health` - Health check

#!/usr/bin/env bash
# Exercise 3 — Multi-container application with Docker Compose
# Usage: bash exercise-3.sh

PROJECT="exercise-3"

# ── Start ──────────────────────────────────────────────────────────────────
echo ">>> Starting services with Docker Compose..."
docker compose up -d

echo ">>> Services are running — open http://localhost:8080 to access WordPress"

# ── Inspect ───────────────────────────────────────────────────────────────
echo ""
echo ">>> Running services:"
docker compose ps

echo ""
echo ">>> Service logs (last 20 lines each):"
docker compose logs --tail=20

echo ""
echo ">>> Named volumes:"
docker volume ls --filter "name=${PROJECT}"

# ── Scale (demo) ──────────────────────────────────────────────────────────
echo ""
echo ">>> Scaling the wordpress service to 2 replicas..."
docker compose up -d --scale wordpress=2 --no-recreate 2>/dev/null || \
  echo "    (scaling skipped — port binding prevents multiple replicas on the same port)"

# ── Exec into a running container ─────────────────────────────────────────
echo ""
echo ">>> PHP version inside the wordpress container:"
docker compose exec wordpress php --version

# ── Stop ──────────────────────────────────────────────────────────────────
echo ""
read -rp "Press Enter to stop all services (data volumes are kept)..."
docker compose stop
echo ">>> Services stopped. Volumes and networks are preserved."

# ── Down & cleanup ────────────────────────────────────────────────────────
echo ""
read -rp "Remove containers and networks as well? [y/N] " answer
if [[ "${answer}" =~ ^[Yy]$ ]]; then
  docker compose down
  echo ">>> Containers and networks removed."
fi

echo ""
read -rp "Also remove named volumes (ALL DATA WILL BE LOST)? [y/N] " answer
if [[ "${answer}" =~ ^[Yy]$ ]]; then
  docker compose down --volumes
  echo ">>> Volumes removed."
fi

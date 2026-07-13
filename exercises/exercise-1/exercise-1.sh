#!/usr/bin/env bash
# Exercise 1 — Build and manage a static nginx container
# Usage: bash exercise-1.sh

IMAGE="exercise-1"
CONTAINER="exercise-1"
PORT=8080

# ── Build ──────────────────────────────────────────────────────────────────
echo ">>> Building image '${IMAGE}' ..."
docker build -t "${IMAGE}" .

# ── Run ───────────────────────────────────────────────────────────────────
echo ">>> Starting container '${CONTAINER}' on port ${PORT} ..."
docker run -d \
  --name "${CONTAINER}" \
  -p "${PORT}:80" \
  "${IMAGE}"

echo ">>> Container is running — open http://localhost:${PORT}"

# ── Inspect ───────────────────────────────────────────────────────────────
echo ""
echo ">>> Running containers:"
docker ps

echo ""
echo ">>> Image details:"
docker image inspect "${IMAGE}" --format \
  'ID: {{.Id}}  Size: {{.Size}}  Created: {{.Created}}'

echo ""
echo ">>> Container logs:"
docker logs "${CONTAINER}"

# ── Stop & remove ──────────────────────────────────────────────────────────
echo ""
read -rp "Press Enter to stop and remove the container..."
docker stop "${CONTAINER}"
docker rm   "${CONTAINER}"
echo ">>> Container stopped and removed."

# ── Cleanup (optional) ────────────────────────────────────────────────────
read -rp "Remove the image as well? [y/N] " answer
if [[ "${answer}" =~ ^[Yy]$ ]]; then
  docker rmi "${IMAGE}"
  echo ">>> Image '${IMAGE}' removed."
fi

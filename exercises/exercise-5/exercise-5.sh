#!/bin/bash
#
# exercise-5.sh
# =============
# Exercise 5: CloudNativePG RBAC Configuration
# 
# This script applies RBAC permissions to all student namespaces,
# allowing students to create and manage CloudNativePG resources.
#
# Prerequisites:
#   - kubectl is installed and configured with admin access
#   - All student namespaces exist (e.g., student-ben-coeppicus)
#
# Usage:
#   ./exercise-5.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║ Exercise 5: CloudNativePG RBAC Configuration                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verify kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ Error: kubectl is not installed or not in PATH"
    exit 1
fi

# Verify we can connect to the cluster
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Error: Cannot connect to Kubernetes cluster"
    echo "   Please verify your kubeconfig is set correctly"
    exit 1
fi

echo "✓ Connected to Kubernetes cluster"
echo ""

# Run the RBAC application script
if [ -f "./apply-cnpg-rbac.sh" ]; then
    chmod +x ./apply-cnpg-rbac.sh
    ./apply-cnpg-rbac.sh
else
    echo "❌ Error: apply-cnpg-rbac.sh not found"
    exit 1
fi

echo ""
echo "✓ Exercise 5 completed successfully!"
echo ""
echo "Next steps:"
echo "  1. Students can now create CNPG clusters in their namespaces"
echo "  2. Example: kubectl apply -f cluster-example.yaml"
echo "  3. See README.md for more information"

#!/bin/bash
# 
# apply-cnpg-rbac.sh
# =================
# Generates and applies CNPG RBAC Role and RoleBinding to all student namespaces.
# This grants the 'student' service account in each namespace full permissions
# to manage CloudNativePG resources.
#
# Usage:
#   ./apply-cnpg-rbac.sh
#

set -e

# List of all students (must match provision.py STUDENTS list)
STUDENTS=(
    "ben-coeppicus"
    "christian-wendel"
    "dirk-rohwer-claussen"
    "fahti-coektue"
    "florian-fulde"
    "janine-bruns"
    "mandy-krueger"
    "marc-richter"
    "maren-tietgen"
    "michael-boose"
    "rainer-moeller"
    "walter-raske"
)

echo "Applying CNPG RBAC permissions to all student namespaces..."
echo ""

for student in "${STUDENTS[@]}"; do
    namespace="student-${student}"
    
    echo "→ Creating CNPG Role and RoleBinding in namespace: $namespace"
    
    kubectl apply -f - <<EOF
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cnpg-admin
  namespace: $namespace
rules:
  # Full permissions on all CNPG cluster resources
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["clusters"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Cluster status subresource
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["clusters/status"]
    verbs: ["get", "patch", "update", "watch"]

  # Backups
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["backups"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Scheduled backups
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["scheduledbackups"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Scheduled backups status
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["scheduledbackups/status"]
    verbs: ["get", "patch", "update", "watch"]

  # Poolers
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["poolers"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Poolers status
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["poolers/status"]
    verbs: ["get", "patch", "update", "watch"]

  # Database resources
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["databases"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Subscriptions
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["subscriptions"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Publications (logical replication)
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["publications"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Failover Quorums
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["failoverquorums"]
    verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]

  # Image Catalogs
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["imagecatalogs"]
    verbs: ["get", "list", "watch"]

  # Cluster Image Catalogs (cluster-scoped)
  - apiGroups: ["postgresql.cnpg.io"]
    resources: ["clusterimagecatalogs"]
    verbs: ["get", "list", "watch"]

  # Standard K8s resources needed by CNPG
  # ConfigMaps in the namespace
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]

  # Secrets in the namespace
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]

  # Services
  - apiGroups: [""]
    resources: ["services"]
    verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]

  # Pods (for debugging and monitoring)
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]

  # Pod logs
  - apiGroups: [""]
    resources: ["pods/log"]
    verbs: ["get"]

  # Persistent Volume Claims (for stateful storage)
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch"]

  # StatefulSets (for CNPG instances)
  - apiGroups: ["apps"]
    resources: ["statefulsets"]
    verbs: ["get", "list", "watch"]

  # Jobs (for backups)
  - apiGroups: ["batch"]
    resources: ["jobs"]
    verbs: ["get", "list", "watch"]

  # Cronjobs (for scheduled backups)
  - apiGroups: ["batch"]
    resources: ["cronjobs"]
    verbs: ["get", "list", "watch"]

  # Events (for troubleshooting)
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["get", "list", "watch"]

  # Namespaces (read access)
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["get", "list", "watch"]

  # Resource Quotas
  - apiGroups: [""]
    resources: ["resourcequotas"]
    verbs: ["get", "list", "watch"]

  # Limit Ranges
  - apiGroups: [""]
    resources: ["limitranges"]
    verbs: ["get", "list", "watch"]

  # Endpoints (service discovery)
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch"]

  # Pod Disruption Budgets (HA management)
  - apiGroups: ["policy"]
    resources: ["poddisruptionbudgets"]
    verbs: ["get", "list", "watch"]

  # Ingress (for connecting to databases)
  - apiGroups: ["networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: cnpg-admin-binding
  namespace: $namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: cnpg-admin
subjects:
  - kind: ServiceAccount
    name: student
    namespace: $namespace
EOF
    
done

echo ""
echo "✓ Successfully applied CNPG RBAC permissions to all student namespaces."
echo ""
echo "Verifying permissions..."

for student in "${STUDENTS[@]}"; do
    namespace="student-${student}"
    echo "  - $namespace: Role and RoleBinding created"
done

echo ""
echo "Students can now create and manage CNPG resources in their namespaces."

# Exercise 5: CloudNativePG (CNPG) RBAC Configuration

## Objective
Grant all student service accounts the necessary Kubernetes RBAC permissions to create, manage, and administrate CloudNativePG (CNPG) resources in their respective namespaces.

## Problem
Without proper RBAC configuration, students get a `Forbidden` error when attempting to create CNPG clusters:

```
Error from server (Forbidden): error when creating "cluster.yaml": 
clusters.postgresql.cnpg.io is forbidden: User 
"system:serviceaccount:student-<name>:student" cannot create resource 
"clusters" in API group "postgresql.cnpg.io" in the namespace 
"student-<name>"
```

## Solution

### Files in this Exercise

1. **cnpg-rbac.yaml** — Template RBAC manifest
   - Defines a `Role` with full CNPG permissions
   - Defines a `RoleBinding` to attach the role to the student service account
   - Contains placeholders (`default`) that must be replaced with actual namespace names

2. **apply-cnpg-rbac.sh** — Automation script
   - Generates per-namespace Role and RoleBinding manifests
   - Applies them to all student namespaces in one operation
   - Requires cluster admin access (typically your admin kubeconfig)

### Permissions Granted

The `cnpg-admin` role grants full CRUD (Create, Read, Update, Delete) access to:

**CNPG Custom Resources:**
- `clusters` — The primary PostgreSQL cluster definition
- `backups` — On-demand backups
- `scheduledbackups` — Scheduled backup jobs
- `poolers` — PgBouncer connection pooling
- `databases` — Database objects
- `publishers` — For PostgreSQL logical replication
- `subscriptions` — For PostgreSQL logical replication
- `clusternetworkpolicies` — Read-only network policies

**Supporting Kubernetes Resources:**
- `configmaps`, `secrets` — Configuration management
- `services` — Network exposure
- `pods` — For debugging and monitoring
- `persistentvolumeclaims` — Storage management
- `statefulsets`, `jobs`, `cronjobs` — Workload management

### How to Apply

#### Option 1: Automated (Recommended)

Make the script executable and run it:

```bash
chmod +x apply-cnpg-rbac.sh
./apply-cnpg-rbac.sh
```

**Prerequisites:**
- You must be authenticated to the Kubernetes cluster with admin access
- Your kubeconfig must point to the correct cluster
- All student namespaces must already exist (`student-<name>`)

#### Option 2: Manual per-Namespace

For each student namespace, edit and apply `cnpg-rbac.yaml`:

```bash
# Replace 'default' with the actual student namespace name
sed 's/namespace: default/namespace: student-ben-coeppicus/g' cnpg-rbac.yaml | kubectl apply -f -
```

### Verification

After applying, verify the permissions are in place:

```bash
# Check the role exists
kubectl get roles cnpg-admin -n student-ben-coeppicus

# Check the role binding exists
kubectl get rolebindings cnpg-admin-binding -n student-ben-coeppicus

# Test permissions (should succeed)
kubectl auth can-i create clusters.postgresql.cnpg.io \
  --as=system:serviceaccount:student-ben-coeppicus:student \
  -n student-ben-coeppicus
```

### Next Steps

Once RBAC is configured, students can:

1. Create CNPG Cluster manifests:
   ```bash
   kubectl apply -f cluster.yaml
   ```

2. Monitor cluster status:
   ```bash
   kubectl get clusters
   kubectl describe cluster my-postgres
   ```

3. Create backups:
   ```bash
   kubectl apply -f backup.yaml
   ```

4. Manage connection pooling:
   ```bash
   kubectl apply -f pooler.yaml
   ```

### Troubleshooting

**Error: "Forbidden" for different resource**
- The role only grants permissions to CNPG and supporting K8s resources
- For other resources, create additional roles as needed

**Error: "Namespace not found"**
- Ensure student namespaces exist (typically created by provision.py)
- Verify the student name matches the `STUDENTS` list in `provision.py`

**Error: "User cannot get namespaces"**
- The script and Role only grant access within the student's own namespace
- They cannot access other namespaces (by design)

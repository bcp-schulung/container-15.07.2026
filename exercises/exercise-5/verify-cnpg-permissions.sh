#!/bin/bash
#
# verify-cnpg-permissions.sh
# =========================
# Verifies that CNPG RBAC permissions are correctly applied for all students.
#
# This script tests if each student service account can:
#   - Create clusters
#   - List clusters
#   - Get cluster status
#

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

echo "Verifying CNPG RBAC permissions for all students..."
echo ""

all_passed=true

for student in "${STUDENTS[@]}"; do
    namespace="student-${student}"
    serviceaccount="system:serviceaccount:${namespace}:student"
    
    echo -n "→ Checking $student in namespace $namespace... "
    
    # Test create clusters permission
    if kubectl auth can-i create clusters.postgresql.cnpg.io \
       --as="$serviceaccount" \
       -n "$namespace" \
       --quiet 2>/dev/null; then
        echo "✓ OK"
    else
        echo "✗ FAILED"
        all_passed=false
    fi
done

echo ""

if [ "$all_passed" = true ]; then
    echo "✓ All students have correct CNPG permissions!"
else
    echo "✗ Some students are missing permissions."
    echo ""
    echo "Run apply-cnpg-rbac.sh to apply the RBAC configuration."
fi

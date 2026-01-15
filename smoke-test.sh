# #!/bin/bash
# set -e

# NAMESPACE="demo"
# TIMEOUT=180

# echo "→ waiting for pods..."
# kubectl wait --for=condition=ready pod -l app=client -n $NAMESPACE --timeout=${TIMEOUT}s
# kubectl wait --for=condition=ready pod -l app=server -n $NAMESPACE --timeout=${TIMEOUT}s
# echo "✓ pods ready"

# MINIKUBE_IP=$(minikube ip)
# NODE_PORT=$(kubectl get svc client -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
# BASE_URL="http://${MINIKUBE_IP}:${NODE_PORT}"

# echo "→ testing client at $BASE_URL..."
# CLIENT_RESPONSE=$(curl -sf $BASE_URL)
# [ -z "$CLIENT_RESPONSE" ] && echo "✗ client failed" && exit 1
# echo "✓ client ok (${#CLIENT_RESPONSE} bytes)"

# echo "→ testing api at $BASE_URL/api/button1..."
# BUTTON1=$(curl -sf $BASE_URL/api/button1)
# echo "$BUTTON1" | grep -q '"ok":true' || { echo "✗ api failed"; exit 1; }
# echo "✓ api ok: $BUTTON1"

# echo ""
# echo "✓ smoke test passed"
# echo "→ open in browser: $BASE_URL"

#!/bin/bash
#!/bin/bash
set -e

NAMESPACE="demo"
TIMEOUT=180

echo "→ waiting for pods..."
kubectl wait --for=condition=ready pod -l app=client -n $NAMESPACE --timeout=${TIMEOUT}s
kubectl wait --for=condition=ready pod -l app=server -n $NAMESPACE --timeout=${TIMEOUT}s
echo "✓ pods ready"

MINIKUBE_IP=$(minikube ip)
NODE_PORT=$(kubectl get svc client -n $NAMESPACE -o jsonpath='{.spec.ports[0].nodePort}')
BASE_URL="http://${MINIKUBE_IP}:${NODE_PORT}"

echo "→ testing client at $BASE_URL..."
CLIENT_RESPONSE=$(curl -sf $BASE_URL)
[ -z "$CLIENT_RESPONSE" ] && echo "✗ client failed" && exit 1
echo "✓ client ok (${#CLIENT_RESPONSE} bytes)"

echo "→ testing api at $BASE_URL/api/button1..."
BUTTON1=$(curl -sf $BASE_URL/api/button1)
echo "$BUTTON1" | grep -q '"ok":true' || { echo "✗ api failed"; exit 1; }
echo "✓ api ok: $BUTTON1"

echo ""
echo "✓ smoke test passed"
echo "→ open in browser: $BASE_URL"

echo ""
echo "→ waiting for consumer pod..."
kubectl wait --for=condition=ready pod -l app=consumer -n $NAMESPACE --timeout=${TIMEOUT}s
echo "✓ consumer pod ready"

echo "→ waiting for consumer to join group (Kafka may still be electing leader)..."
for i in {1..30}; do
  if kubectl logs -n $NAMESPACE deploy/consumer --since=240s | grep -q "Consumer has joined the group"; then
    echo "✓ consumer joined group ✅"
    break
  fi
  sleep 2
done

kubectl logs -n $NAMESPACE deploy/consumer --since=240s | grep -q "Consumer has joined the group" \
  || { echo "✗ consumer did not join group in time"; exit 1; }

echo "→ sending another event to ensure consumer receives after stabilization..."
BUTTON1_AGAIN=$(curl -sf $BASE_URL/api/button1)
echo "$BUTTON1_AGAIN" | grep -q '"ok":true' || { echo "✗ api failed on second send"; exit 1; }
echo "✓ api ok (second send): $BUTTON1_AGAIN"

echo "→ waiting for consumer to receive message..."
for i in {1..30}; do
  if kubectl logs -n $NAMESPACE deploy/consumer --since=240s | grep -q "Step: received"; then
    echo "✓ consumer received message ✅"
    break
  fi
  sleep 2
done

kubectl logs -n $NAMESPACE deploy/consumer --since=240s | grep -q "Step: received" \
  || { echo "✗ consumer did not receive messages"; exit 1; }

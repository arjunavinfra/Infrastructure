
#!/bin/bash -x
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl apply -k $SCRIPT_DIR -n argocd


NAMESPACE="argocd"
MAX_WAIT_TIME=180  # 3 minutes in seconds

# Start time for tracking elapsed time
START_TIME=$(date +%s)

# Function to check if all pods are ready
check_pods_ready() {
    local ready_pods
    ready_pods=$(kubectl get pods --namespace="$NAMESPACE" --no-headers | grep -v 'Completed\|Running\|Succeeded' | wc -l)
    if [ "$ready_pods" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

echo "Waiting for pods in namespace $NAMESPACE to become ready..."

# Loop to wait until all pods are ready or timeout occurs
while true; do
    # Check if all pods are ready
    if check_pods_ready; then
        echo "All pods in namespace $NAMESPACE are ready."
        exit 0
    fi

    # Check if timeout occurred
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    if [ "$ELAPSED_TIME" -ge "$MAX_WAIT_TIME" ]; then
        echo "Timeout: All pods in namespace $NAMESPACE did not become ready within 3 minutes."
        exit 1
    fi

    # Print current status and wait for a short interval before checking again
    echo "Some pods are not ready. Waiting for $MAX_WAIT_TIME seconds before checking again..."
    kubectl get pods --namespace="$NAMESPACE"
    sleep 5
done

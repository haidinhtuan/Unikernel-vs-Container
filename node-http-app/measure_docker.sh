#!/bin/bash

# Measure the boot time of a Docker container using HTTP readiness

PORT=8080
URL="http://localhost:${PORT}/hello"
TIMEOUT=20  # seconds

echo -e "\033[1;34mMeasuring Docker container boot time...\033[0m"

# Record start time in milliseconds
start=$(date +%s%3N)

# Run the Docker container in detached mode
docker run -d --rm \
    -p ${PORT}:${PORT} \
    --name go-app-constrained \
    --cpus="8.0" \
    --memory="2048m" \
    node-http-app:docker > /dev/null

# Ensure cleanup on Ctrl+C
trap "echo -e '\n\033[1;33mAborting, cleaning up...\033[0m'; docker stop go-app-constrained > /dev/null; exit 1" SIGINT

SECONDS_WAITED=0
while ! curl -sf "${URL}" > /dev/null; do
    sleep 0.05
    SECONDS_WAITED=$(echo "$SECONDS_WAITED + 0.05" | bc)
    if (( $(echo "$SECONDS_WAITED > $TIMEOUT" | bc -l) )); then
        echo -e "\033[1;31mError: Timeout after ${TIMEOUT}s waiting for container readiness.\033[0m"
        docker stop go-app-constrained > /dev/null
        exit 1
    fi
done

# Record end time in milliseconds
end=$(date +%s%3N)

# Calculate and display boot time
boot_time=$((end - start))
echo -e "\033[1;32mDocker container boot time: ${boot_time} ms\033[0m"

# Cleanup: stop the container after measurement
docker stop go-app-constrained > /dev/null

exit 0

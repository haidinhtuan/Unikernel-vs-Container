#!/bin/bash

# Measure the boot time of a Nanos unikernel using HTTP readiness

PORT=8080
URL="http://localhost:${PORT}/hello"
TIMEOUT=20  # seconds

echo -e "\033[1;34mMeasuring Nanos unikernel boot time...\033[0m"

start=$(date +%s%3N)

# Run the unikernel
ops run -p ${PORT}-${PORT} --smp 8 -m 2048M myapp &
unikernel_pid=$!

trap "echo -e '\n\033[1;33mAborting, cleaning up...\033[0m'; kill $unikernel_pid; exit 1" SIGINT

SECONDS_WAITED=0
while ! curl -sf "${URL}" > /dev/null; do
    sleep 0.05
    SECONDS_WAITED=$(echo "$SECONDS_WAITED + 0.05" | bc)
    if (( $(echo "$SECONDS_WAITED > $TIMEOUT" | bc -l) )); then
        echo -e "\033[1;31mError: Timeout after ${TIMEOUT}s waiting for unikernel readiness.\033[0m"
        kill $unikernel_pid
        exit 1
    fi
done

end=$(date +%s%3N)
boot_time=$((end - start))
echo -e "\033[1;32mBoot time: ${boot_time} ms\033[0m"

kill $unikernel_pid

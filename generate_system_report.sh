#!/bin/bash
#
# Generates a comprehensive hardware and software configuration report.
#

# Define the output file
REPORT_FILE="system_report_$(date +%Y-%m-%d).txt"

# --- Header ---
echo "System Configuration Report" > "$REPORT_FILE"
echo "Generated on: $(date)" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "=================================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"


# --- Hardware Information ---
echo "### Hardware Information ###" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- System Model ---" >> "$REPORT_FILE"
sudo dmidecode -t system >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- CPU Information ---" >> "$REPORT_FILE"
lscpu >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Memory (RAM) Information ---" >> "$REPORT_FILE"
echo "[Summary]" >> "$REPORT_FILE"
free -h >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "[Detailed Memory Slots]" >> "$REPORT_FILE"
sudo dmidecode -t memory >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Storage Information ---" >> "$REPORT_FILE"
echo "[Block Devices (Disks & Partitions)]" >> "$REPORT_FILE"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "[Filesystem Usage]" >> "$REPORT_FILE"
df -hT >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Network Interfaces ---" >> "$REPORT_FILE"
ip -br -c a >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"


# --- Software Information ---
echo "### Software Information ###" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Operating System & Kernel ---" >> "$REPORT_FILE"
cat /etc/os-release >> "$REPORT_FILE"
echo "Kernel: $(uname -a)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "--- Key Application Versions ---" >> "$REPORT_FILE"
# Check for each command before running to avoid errors
if command -v go &> /dev/null; then
    echo "Go: $(go version)" >> "$REPORT_FILE"
fi
if command -v node &> /dev/null; then
    echo "Node.js: $(node -v)" >> "$REPORT_FILE"
fi
if command -v docker &> /dev/null; then
    echo "Docker: $(docker --version)" >> "$REPORT_FILE"
    echo "Docker Info (Storage Driver): $(docker info 2>/dev/null | grep 'Storage Driver')" >> "$REPORT_FILE"
fi
if command -v ops &> /dev/null; then
    echo "OPS: $(ops version)" >> "$REPORT_FILE"
fi
if command -v qemu-system-x86_64 &> /dev/null; then
    echo "QEMU: $(qemu-system-x86_64 --version | head -n 1)" >> "$REPORT_FILE"
fi
if command -v wrk &> /dev/null; then
    echo "wrk: $(wrk -v)" >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

echo "Report complete. Saved to: $REPORT_FILE"

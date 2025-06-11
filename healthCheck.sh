#!/bin/bash

# Setup
mkdir -p ./logs  # Ensure logs directory exists
logFile="./logs/$(date +%F).log"  # Log file with today's date

# Function to log with timestamp
log() {
  echo "[$(TZ='Asia/Kolkata' date '+%Y-%m-%d %H:%M:%S')] $1" >> "$logFile"
}

#Email configuraion
ALERT_EMAIL="saksham.sakshu08@gmail.com"

sendAlert() {
  subject="$1"
  body="$2"
  echo "$body" | mail -s "$subject" "$ALERT_EMAIL"
}

# Print section header
echo "==========================================" | tee -a "$logFile"
echo "Running system health check at $(TZ='Asia/Kolkata' date '+%Y-%m-%d %H:%M:%S')" | tee -a "$logFile"
echo "==========================================" | tee -a "$logFile"

#CPU Usage
CPU_IDLE=$(top -bn1 | awk '/%Cpu/ {print $8}' | cut -d. -f1)

if [[ -z "$CPU_IDLE" ]]; then
  CPU="N/A"
  echo "CPU Usage: Unable to determine" | tee -a "$logFile"
else
  CPU=$((100 - CPU_IDLE))
  log "CPU Usage: $CPU%"
  echo "CPU Usage: $CPU%"

  if (( CPU > 90 )); then
    echo "WARNING: High CPU usage is detected!" | tee -a "$logFile"
    sendAlert "High CPU usage alert!" "CPU usage is critically high at $CPU% on $(hostname)"
  fi
fi

#Memory Usage
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

if [[ -z "$MEM_TOTAL" || -z "$MEM_AVAILABLE" ]]; then
  MEM="N/A"
  echo "Memory Usage: Unable to determine" | tee -a "$logFile"
else
  MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))
  MEM=$((MEM_USED * 100 / MEM_TOTAL))
  log "Memory Usage: $MEM%"
  echo "Memory Usage: $MEM%"

  if (( MEM > 90 )); then
    echo "WARNING: High Memory usage is detected!" | tee -a "$logFile"
    sendAlert "High memory usage alert" "Memory usage is critically high at $MEM% on $(hostname)"
  fi
fi

#Disk Usage
DISK=$(df / | awk 'END {print $5}' | sed 's/%//')
log "Disk Usage: $DISK%"
echo "Disk Usage: $DISK%"

if (( DISK > 90 )); then
  echo "WARNING: High Disk usage is detected!" | tee -a "$logFile"
  sendAlert "High disk usage alert" "Disk usage is critically high at $DISK% on $(hostname)"
fi

#Internet Connectivity
ping -c 1 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
  log "Internet is fine"
  echo "Internet is fine"
else
  log "Internet seems to be down!"
  echo "WARNING: Internet seems to be down!" | tee -a "$logFile"
  sendAlert "Internet down alert!" "Internet is not reachable on $(hostname)"
fi

#Fake Service Check
SERVICE_SCRIPT="./fakeService.sh"

if pgrep -f "$SERVICE_SCRIPT" > /dev/null; then
  log "Fake service is running..."
  echo "Fake service is running..."
else
  log "Fake service is not running. Restarting it..."
  echo "Fake service is not running. Restarting it..."

  nohup bash "$SERVICE_SCRIPT" > /dev/null 2>&1 &
  sleep 2

  if pgrep -f "$SERVICE_SCRIPT" > /dev/null; then
    log "Fake service restarted successfully."
    echo "Fake service restarted successfully."
  else
    log "Failed to restart fake service."
    echo "Failed to restart fake service." | tee -a "$logFile"
    sendAlert "Fake service restart failed" "Fake service could not be restarted on $(hostname)"
  fi
fi

#Completion
echo "Health Check Completed" | tee -a "$logFile"


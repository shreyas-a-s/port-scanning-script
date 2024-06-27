#!/usr/bin/env bash

# Check if the user provided an IP address
if [ -z "$1" ]; then
  echo "Usage: $0 <IP_ADDRESS> [start_port] [end_port]"
  exit 1
fi

IP_ADDRESS=$1
START_PORT=${2:-1}
END_PORT=${3:-65535}

echo "Starting port scan on $IP_ADDRESS from port $START_PORT to $END_PORT..."

if ! command -v nc &> /dev/null; then
  for ((port=START_PORT; port<=END_PORT; port++)); do
    timeout 1 bash -c "echo >/dev/tcp/\"$IP_ADDRESS\"/$port" &>/dev/null && echo "Port $port is open"
  done
else
  for ((port=START_PORT; port<=END_PORT; port++)); do
    timeout 1 nc -z -w 1 "$IP_ADDRESS" $port &>/dev/null && echo "Port $port is open"
  done
fi


echo "Port scan completed."

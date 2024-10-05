#!/bin/bash

webhook_url=$(awk -F' *= *' '/AgentStatusWebhook/ {print $2}' config/config.ini | tr -d '\r\n')

hostname=$(hostname)
username=$(whoami)
is_admin=$(groups | grep -q "sudo" && echo "True" || echo "False")
os_name=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '=' -f2 | tr -d '"')
kernel_version=$(uname -r)
architecture=$(uname -m)
manufacturer=$(cat /sys/class/dmi/id/chassis_vendor 2>/dev/null || echo "N/A")
board_product=$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo "N/A")
bios_version=$(cat /sys/class/dmi/id/bios_version 2>/dev/null || echo "N/A")
total_memory=$(free -h | awk '/^Mem:/ {print $2}')
memory_used=$(free -h | awk '/^Mem:/ {print $3}')
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
public_ip=$(curl -s ifconfig.me)
private_ip=$(hostname -I | awk '{print $1}')
default_gateway=$(ip r | grep default | awk '{print $3}')

drives=$(df -h --output=source,size,avail | grep '^/dev/' | awk '{print "Drive: " $1 ", Capacity: " $2 ", Free Space: " $3}' | tr '\n' '\n')

escape_json() {
  python3 -c 'import json, sys; print(json.dumps(sys.stdin.read()))' <<< "$1"
}

json_payload=$(cat <<EOF
{
  "embeds": [
    {
      "title": "$hostname System Information",
      "fields": [
        {
          "name": "Hostname",
          "value": $(escape_json "$hostname"),
          "inline": true
        },
        {
          "name": "User",
          "value": $(escape_json "$username"),
          "inline": true
        },
        {
          "name": "Is Admin",
          "value": $(escape_json "$is_admin"),
          "inline": true
        },
        {
          "name": "OS Name",
          "value": $(escape_json "$os_name"),
          "inline": true
        },
        {
          "name": "Kernel Version",
          "value": $(escape_json "$kernel_version"),
          "inline": true
        },
        {
          "name": "Architecture",
          "value": $(escape_json "$architecture"),
          "inline": true
        },
        {
          "name": "Manufacturer",
          "value": $(escape_json "$manufacturer"),
          "inline": true
        },
        {
          "name": "Baseboard Product",
          "value": $(escape_json "$board_product"),
          "inline": true
        },
        {
          "name": "BIOS Version",
          "value": $(escape_json "$bios_version"),
          "inline": true
        },
        {
          "name": "Total Memory",
          "value": $(escape_json "$total_memory"),
          "inline": true
        },
        {
          "name": "Memory Used",
          "value": $(escape_json "$memory_used"),
          "inline": true
        },
        {
          "name": "CPU Usage",
          "value": $(escape_json "$cpu_usage"),
          "inline": true
        },
        {
          "name": "Public IP Address",
          "value": $(escape_json "$public_ip"),
          "inline": true
        },
        {
          "name": "Private IP Address",
          "value": $(escape_json "$private_ip"),
          "inline": true
        },
        {
          "name": "Default Gateway",
          "value": $(escape_json "$default_gateway"),
          "inline": true
        },
        {
          "name": "Drives",
          "value": $(escape_json "$drives"),
          "inline": false
        }
      ]
    }
  ]
}
EOF
)

curl -H "Content-Type: application/json" -X POST -d "$json_payload" "$webhook_url"

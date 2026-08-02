#!/usr/bin/env bash

set -Eeuo pipefail

NETBIRD_INTERFACE="wt0"

TCP_PORTS=(
  8429  # vmagent
  8686  # Vector API
  8428  # VictoriaMetrics
  8089  # VictoriaMetrics ingestion
  9428  # VictoriaLogs
  3000  # Grafana
  8427  # vmauth
  9100  # node-exporter
  8088  # cAdvisor (host port)
)

UDP_PORTS=(
  8089  # VictoriaMetrics ingestion
)

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: this script must be run as root." >&2
  exit 1
fi

if ! command -v ufw >/dev/null 2>&1; then
  echo "ERROR: ufw is not installed." >&2
  exit 1
fi

if ! ip link show "${NETBIRD_INTERFACE}" >/dev/null 2>&1; then
  echo "ERROR: NetBird interface '${NETBIRD_INTERFACE}' does not exist." >&2
  exit 1
fi

delete_rule_if_present() {
  local action="$1"
  local port="$2"
  local proto="$3"

  ufw --force delete "${action}" "${port}/${proto}" >/dev/null 2>&1 || true
}

echo "Removing existing observability-port rules..."

for port in "${TCP_PORTS[@]}"; do
  delete_rule_if_present allow "${port}" tcp
  delete_rule_if_present deny  "${port}" tcp
done

for port in "${UDP_PORTS[@]}"; do
  delete_rule_if_present allow "${port}" udp
  delete_rule_if_present deny  "${port}" udp
done

echo "Allowing observability ports through ${NETBIRD_INTERFACE}..."

for port in "${TCP_PORTS[@]}"; do
  ufw allow in on "${NETBIRD_INTERFACE}" \
    to any port "${port}" proto tcp \
    comment "Observability via NetBird"
done

for port in "${UDP_PORTS[@]}"; do
  ufw allow in on "${NETBIRD_INTERFACE}" \
    to any port "${port}" proto udp \
    comment "Observability via NetBird"
done

echo "Denying observability ports on other interfaces..."

for port in "${TCP_PORTS[@]}"; do
  ufw deny in to any port "${port}" proto tcp \
    comment "Block public observability access"
done

for port in "${UDP_PORTS[@]}"; do
  ufw deny in to any port "${port}" proto udp \
    comment "Block public observability access"
done

ufw reload

echo
echo "Resulting UFW rules:"
ufw status numbered

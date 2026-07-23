# Lab 3: VictoriaLogs And Metrics Integration

This lab runs a single-node VictoriaMetrics and VictoriaLogs observability stack for a VPS. It collects host metrics, container metrics, Docker logs, and selected host log files, then makes them available in Grafana.

## What This Lab Uses

- **VictoriaLogs single-node** as the log storage and query engine.
- **Vector** as the log collector for Docker logs and selected `/var/log` files.
- **VictoriaMetrics single-node** for metrics storage.
- **vmagent** for scraping metrics targets and remote-writing them to VictoriaMetrics.
- **node-exporter** for VPS host metrics.
- **cAdvisor** for Docker container metrics.
- **vmauth** to route API requests between VictoriaMetrics and VictoriaLogs based on request paths.
- **Grafana** with VictoriaMetrics and VictoriaLogs datasources.
- **Docker Compose** to run the full single-node lab stack.

Alerting files are kept in the repository for later, but `vmalert` and Alertmanager are commented out in the active compose file.

## What The Lab Does

The stack starts two pipelines:

1. `vmagent` scrapes VictoriaMetrics, VictoriaLogs, Vector, node-exporter, cAdvisor, and itself.
2. `vmagent` remote-writes metrics to VictoriaMetrics.
3. `vector` reads Docker logs and selected host logs from `/var/log`.
4. `vector` parses JSON Docker messages when possible.
5. `vector` sends logs to VictoriaLogs through the Elasticsearch-compatible ingestion endpoint.
6. Grafana queries VictoriaMetrics and VictoriaLogs through provisioned datasources.
7. `vmauth` routes `/api/v1/...` requests to VictoriaMetrics and `/select/...` requests to VictoriaLogs.

## How To Run

From the repository root, run:

```bash
docker compose -f Observability/VictoriaMetrics/Lab3/deployment/docker/compose-vmvl-single.yml up -d
```

To stop and remove containers and volumes, use the same compose file with `down -v`:

```bash
docker compose -f Observability/VictoriaMetrics/Lab3/deployment/docker/compose-vmvl-single.yml down -v
```

Main local ports:

- Grafana: `http://localhost:3000`
- VictoriaMetrics: `http://localhost:8428`
- VictoriaLogs: `http://localhost:9428`
- vmauth: `http://localhost:8427`
- Vector API: `http://localhost:8686`
- node-exporter: `http://localhost:9100`
- cAdvisor: `http://localhost:8080`

## What You Learn

After completing this lab, you should understand:

- How VictoriaLogs stores and queries application and container logs.
- How Vector collects Docker logs and forwards them to VictoriaLogs.
- How VictoriaLogs can ingest logs through an Elasticsearch-compatible endpoint.
- How log stream fields, timestamp fields, and message fields are mapped during ingestion.
- How Grafana can query logs through the VictoriaMetrics Logs datasource plugin.
- How vmauth can route requests to different VictoriaMetrics components by API path.
- How to combine metrics and logs into one observability workflow.


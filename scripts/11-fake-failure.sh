#!/bin/bash
set -euo pipefail

echo "+++ :rocket: Deploying to Production"
echo ""
echo "  Environment: production"
echo "  Region:      us-east-1"
echo "  Cluster:     prod-k8s-main"
echo "  Image:       registry.example.com/api-server:v2.14.7-rc3"
echo ""
sleep 1

echo "  Pulling container image..."
echo "  v2.14.7-rc3: Pulling from registry.example.com/api-server"
echo "  a3ed95caeb02: Already exists"
echo "  1db09adb07aa: Already exists"
echo "  f9d42c108fd8: Pull complete"
echo "  6b135581b68a: Pull complete"
echo "  Digest: sha256:3e8c9f7b2d1a5f4e6c8b0a9d7e5f3c1b"
echo "  Status: Downloaded newer image for registry.example.com/api-server:v2.14.7-rc3"
sleep 1

echo ""
echo "  Rolling update..."
echo "  deployment.apps/api-server configured"
echo "  Waiting for rollout: 0 of 3 updated replicas available..."
echo "  Waiting for rollout: 1 of 3 updated replicas available..."
echo "  Waiting for rollout: 2 of 3 updated replicas available..."
sleep 1

echo ""
echo "  ❌ Health check failed!"
echo ""
echo "  ❌ Pod api-server-7d4f8b6c9-x2k4p: CrashLoopBackOff"
echo "  ❌ Pod api-server-7d4f8b6c9-m9n3q: CrashLoopBackOff"
echo ""
echo "  Container logs (api-server-7d4f8b6c9-x2k4p):"
echo "  ────────────────────────────────────────────────"
echo "  2026-02-23T06:30:01Z [INFO]  Starting api-server v2.14.7-rc3"
echo "  2026-02-23T06:30:01Z [INFO]  Loading configuration from /etc/api-server/config.yaml"
echo "  2026-02-23T06:30:01Z [INFO]  Connecting to database..."
echo "  2026-02-23T06:30:02Z [ERROR] Failed to connect to database: connection refused"
echo "  2026-02-23T06:30:02Z [ERROR]   host=db-prod-primary.internal port=5432"
echo "  2026-02-23T06:30:02Z [ERROR]   error: dial tcp 10.0.3.42:5432: connect: connection refused"
echo "  2026-02-23T06:30:02Z [FATAL] Cannot start without database connection. Exiting."
echo "  ────────────────────────────────────────────────"
echo ""
echo "  kubectl describe pod api-server-7d4f8b6c9-x2k4p:"
echo "    State:         Waiting"
echo "    Reason:        CrashLoopBackOff"
echo "    Last State:    Terminated (Error, exit code 1)"
echo "    Restart Count: 4"
echo ""
echo "  ❌ Deployment failed: rollout deadline exceeded"
echo ""

echo "  Rolling back to v2.14.6..."
echo "  deployment.apps/api-server rolled back"
echo "  ✅ Rollback successful — v2.14.6 is healthy"

echo ""
echo "--- :mag: Summary Results"
printf '\033]1338;url='"'"'https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExZjBrMW0xdW1zbHd4NjRpOWlpN3J3c2ZtcThqc3V3NzlrNjJhcnZpZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Vuw9m5wXviFIQ/giphy.gif'"'"';alt='"'"'Summary'"'"'\a\n'

echo ""
exit 1

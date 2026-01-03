#!/bin/sh
set -e

echo "Waiting for services to be available on network..."

# Wait for backend and frontend HTTP endpoints to be reachable before starting nginx.
echo "Waiting for backend and frontend HTTP endpoints to be available..."
MAX_ATTEMPTS=60
ATTEMPT=0
SLEEP=1

check_url() {
  url="$1"
  curl --fail --silent --show-error --max-time 3 "$url" >/dev/null 2>&1
}

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))
  echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: checking backend and frontend..."
    if ( check_url "http://backend:8000/docs" || check_url "http://policymaking-backend:8000/docs" ) \
      && ( check_url "http://frontend:3000/" || check_url "http://policymaking-frontend:3000/" ); then
    echo "Both backend and frontend are reachable. Starting nginx."
    exec nginx -g "daemon off;"
  fi
  sleep $SLEEP
done

echo "WARNING: services not reachable after $MAX_ATTEMPTS attempts — starting nginx anyway."
exec nginx -g "daemon off;"

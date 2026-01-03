FROM nginx:alpine

# Copy custom config and startup script
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh

# Make startup script executable
RUN chmod +x /start.sh

# Install utilities for waiting on services (curl for HTTP checks)
RUN apk add --no-cache curl bind-tools

# Health check
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

EXPOSE 80

# Use startup script instead of default entry point
ENTRYPOINT ["/start.sh"]

CMD ["nginx", "-g", "daemon off;"]

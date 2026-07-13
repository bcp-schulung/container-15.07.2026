# syntax=docker/dockerfile:1
# ─────────────────────────────────────────────────────────────────────────────
# Hardened static nginx image  — Container Seminar Exercise 2
#
# Security controls applied:
#   • Pinned base-image version (no floating 'latest' or 'alpine' tag)
#   • apk packages upgraded to pull latest Alpine security patches
#   • All setuid / setgid bits stripped from the entire filesystem
#   • Runs as the built-in unprivileged 'nginx' user (uid 101)
#   • Listens on port 8080 — no CAP_NET_BIND_SERVICE privilege needed
#   • Static content is read-only (444 files, 555 directory)
#   • HTTP security headers enforced by nginx (X-Frame-Options, CSP, etc.)
#   • server_tokens off — nginx version not disclosed in HTTP responses
#   • Package cache cleared at build time; no index files at runtime
#   • HEALTHCHECK defined so orchestrators detect unresponsive containers
# ─────────────────────────────────────────────────────────────────────────────
FROM nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10

# Apply latest Alpine security patches and clear package cache
RUN apk upgrade --no-cache && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Strip setuid / setgid bits from every file on the image filesystem
RUN find / -xdev \( -perm -4000 -o -perm -2000 \) -exec chmod a-s {} + 2>/dev/null || true

# Prepare writable runtime directories for the unprivileged nginx user
RUN install -d -m 0750 -o nginx -g nginx \
        /var/cache/nginx/client_temp \
        /var/cache/nginx/proxy_temp \
        /var/cache/nginx/fastcgi_temp \
        /var/cache/nginx/uwsgi_temp \
        /var/cache/nginx/scgi_temp && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

# Install the hardened nginx configuration (owned by root, readable by all)
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod 444 /etc/nginx/nginx.conf

# Install static content with read-only permissions
COPY --chown=nginx:nginx index.html /usr/share/nginx/html/index.html
RUN chmod 444 /usr/share/nginx/html/index.html && \
    chmod 555 /usr/share/nginx/html

# Drop to non-root for all subsequent layers and at runtime
USER nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO /dev/null http://127.0.0.1:8080/ || exit 1

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

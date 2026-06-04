server {
    listen ${LISTEN_PORT};

location /static/static/ {
        root /vol/web;
    }

    location /static/media/ {
        root /vol/web;
    }

    location / {
        include              gunicorn_headers;
        proxy_redirect       off;
        proxy_pass           http://${APP_HOST}:${APP_PORT};
        client_max_body_size 10M;
    }
}

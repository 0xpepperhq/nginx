worker_processes auto;
events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    upstream service_1 {
        server service_1.railway.internal; # Internal URL for service_1
    }

    upstream service_2 {
        server service_2-ethereum.railway.internal; # Internal URL for service_2
    }

    upstream service_3 {
        server service_3.railway.internal; # Internal URL for service_3
    }

    upstream service_4 {
        server wallet-api-base.railway.internal; # Internal URL for service_4
    }

    server {
        listen 80;
        server_name api.0xpepper.com;

        location /service_1 {
            proxy_pass http://service_1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /ethereum/wallet {
            proxy_pass http://wallet_ethereum;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Chain ID 8453 routes (Base)
        location /base/router {
            proxy_pass http://router_base;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location /base/wallet {
            proxy_pass http://wallet_base;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}

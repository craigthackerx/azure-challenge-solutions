FROM nginx:latest

RUN mkdir -p /var/log/nginx/jenkins
COPY fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY wildcard.craigthacker.dev.key /etc/nginx/ssl/wildcard.craigthacker.dev.key
COPY nginx.conf /etc/nginx/nginx.conf
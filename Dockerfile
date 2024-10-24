FROM nginx:alpine

COPY survey.html /usr/share/nginx/html/

EXPOSE 8080
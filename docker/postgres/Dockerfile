FROM postgres:latest
ENV POSTGRES_USER=docker
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=taxi_db
RUN apt-get update -y
RUN apt-get install -y vim git
COPY ./db_idz.sql /docker-entrypoint-initdb.d/10-init.sql
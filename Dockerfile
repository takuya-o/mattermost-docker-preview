# Copyright (c) 2016 Mattermost, Inc. All Rights Reserved.
# See License.txt for license information.
FROM debian:jessie

#
# Configure SQL
#

ENV MYSQL_ROOT_PASSWORD=0909longpass!
ENV MYSQL_USER=mmuser
ENV MYSQL_PASSWORD=mostests
ENV MYSQL_DATABASE=mattermost_test

ENV DEBIAN_FRONTEND		noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN	true

#
# Configure Mattermost
#
WORKDIR /mm

#Debian upgrade
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y ca-certificates mysql-client
RUN apt-get autoremove -y && apt-get clean all

# Copy over files
ADD https://releases.mattermost.com/3.2.0/mattermost-team-3.2.0-linux-amd64.tar.gz .
RUN tar -zxvf ./mattermost-team-3.2.0-linux-amd64.tar.gz
RUN rm ./mattermost-team-3.2.0-linux-amd64.tar.gz
ADD config_docker.json ./mattermost/config/config_docker.json
ADD docker-entry.sh . 

RUN chmod +x ./docker-entry.sh
ENTRYPOINT ./docker-entry.sh

# Create default storage directory
RUN mkdir ./mattermost-data
VOLUME ./mattermost-data

# from mysql:5.7
COPY docker-entrypoint.sh /entrypoint.sh

# Ports
EXPOSE 8065

#################################################################
# Dockerfile for the PHP-Apache service
#
# @author: Vanessa Richie Alia-Trapero <vrat.engr@gmail.com>
#################################################################

# if using docker compose, this will only be called if the service specified a "build" instead of "image" option and sets this as the build's source

# Common keywords:
# FROM          — set the base image
# RUN           — execute a command in the container
# COPY          — supports the basic copying of local files into the container
# ENV           — set environment variable
# WORKDIR       — set the working directory
# ENTRYPOINT    — set the image’s main command, allowing that image to be run as though it was that command
# VOLUME        — create mount-point for a volume
# CMD           — set executable for container

# base image
FROM php:8.2-apache

# update packages in the server and upgrade with auto "yes" on prompts
RUN apt-get update && apt-get upgrade -y

# install PHPs MySQLi extension since we'll be using it for queries later
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# this is optional, just needed it for debugging files in container
RUN apt-get install nano

# copy ssl certificates to container, then make sure your vhost is using the container's path to the certificates
COPY config/cert/* /etc/ssl/certs/.

# add a new vhost file for our new app
COPY config/vhost.conf /etc/apache2/sites-available/.
# then enable the new vhost <vhost is the filename of the new .conf file>, this will create a file in the /etc/apache2/sites-enabled folder
RUN a2ensite vhost
# and enable necessary modules needed for the ssl portion of our vhost
RUN a2enmod ssl
# enable rewrite module if necessary (eg: using htaccess)
# RUN a2enmod rewrite

# add a new conf for the servername, this is to fix warnings about fully qualified domain name could not be determined
COPY config/servername.conf /etc/apache2/conf-available/.
# then enable the new conf, this will create a file in /etc/apache2/conf-enabled folder
RUN a2enconf servername

# restart apache since there are server changes
RUN service apache2 restart 

############################################################
# DEPLOYING THE CODE INTO THE CONTAINER
# choose only one of the options below
# option 1: for local development, we can use a mounted volume, which receives real time changes from our host files, see volumes in the compose file

# option 2: copy the source file from our host's html folder into the container's apache web directory ("/var/www/html"), but this is only a copy, so when we make changes in our local file, it does not change the one in the container, could be fine in production
# COPY html /var/www/html

# option 3: clone a repo into apache's web directory, you may clone by ssh but make sure to setup the ssh keys and config
#           I'm using https for poduction since we won't really be pushing in the production server and we also don't want it to be bound in our host files as incidental changes will go thru live
#           ps: if you're using github with https, make sure the repo is public
#           user:group 1000 is to allow host system to edit files in the mounted volume in the container
# RUN apt-get -y install git \
#     && cd /var/www \
#     && git clone <your-repo> html \
#     && chown -R 1000:1000 html
############################################################
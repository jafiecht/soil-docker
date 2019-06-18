#This is the container for the webtool, api, and server processing
#Base image
FROM geographica/gdal2:2.2.4


#######################################################
#Set working directory
WORKDIR /app/client

#Install and cache web app dependencies
COPY client/package.json ./
COPY client/yarn.lock ./
RUN yarn install
COPY client/ ./
RUN yarn run build
CMD ["yarn", "start"]

#
WORKDIR /app/server






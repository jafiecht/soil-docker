#This is the container for the webtool, api, and server processing
#Base image


#Setup for the webtool
#######################################################
FROM geographica/gdal2:2.2.4 as base

RUN apt-get update
RUN apt-get -y install curl apt-transport-https build-essential ca-certificates gnupg2 apt-utils

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get -y install yarn

#A few dev needs...
RUN apt-get -y install vim

#Setup for the webtool
#######################################################
#Set working directory
WORKDIR /app/client

#Install and cache web app dependencies
COPY client/package.json ./
COPY client/yarn.lock ./
RUN yarn install
COPY client/ ./
RUN yarn run build


#Setup for the server
#######################################################
FROM base as release

WORKDIR /app/
COPY --from=base /app/client/build ./client/build/

WORKDIR /app/server
COPY server/package.json ./
COPY server/yarn.lock ./
RUN yarn install
COPY server/ ./

#ENV PORT 8001

#EXPOSE 8001

CMD ["yarn", "start"]





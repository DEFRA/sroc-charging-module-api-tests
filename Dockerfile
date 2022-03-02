# We use the Debian-based node:16-slim image to build from -- it's a little larger than Alpine, but allows us to install
# the required Cypress dependencies (not all of which are available for Alpine). This gives us an image size of ~1.16GB
# whereas using the official cypress:base image gives an image size of ~2.26GB
FROM node:16-slim AS node_base

# Install Cypress dependencies
# https://docs.cypress.io/guides/continuous-integration/introduction#Dependencies
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libgbm-dev \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  xvfb \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

# Get the latest version of npm at time of build, regardless of node version, for speed and fixes.
RUN npm i npm@latest -g

# We have chosen /home/node as our working directory to be consistent with https://github.com/DEFRA/defra-docker-node
# WORKDIR /home/node

FROM node_base

# Install dependencies
COPY . .
RUN mkdir environments && \
  npm ci

CMD ["npm", "run", "cy:run:docker"]

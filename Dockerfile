# We use the Debian-based node:16-slim image to build from -- it's a little larger than Alpine, but allows us to install
# the required Cypress dependencies (not all of which are available for Alpine). This gives us an image size of ~1.16GB
# whereas using the official cypress:base image gives an image size of ~2.26GB
FROM node:16-slim

# Install Cypress dependencies
# https://docs.cypress.io/guides/continuous-integration/introduction#Dependencies
RUN apt-get update && \
  apt-get upgrade && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libgbm-dev \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

# Get the latest version of npm at time of build, regardless of node version, for speed and fixes.
RUN npm i npm@latest -g

# Install dependencies
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install

# Copy across our Cypress files
COPY ./environments ./environments
COPY ./cypress ./cypress
COPY ./cypress.json ./cypress.json

CMD ["npm", "run", "cy:run:docker"]

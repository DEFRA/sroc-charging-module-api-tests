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
  libxtst6 \
  xauth \
  xvfb \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

# Get the latest version of npm at time of build, regardless of node version, for speed and fixes.
RUN npm i npm@latest -g

FROM node_base AS production

# We have chosen /home/node as our working directory to be consistent with https://github.com/DEFRA/defra-docker-node
WORKDIR /home/node/app

# We need to set the use in npm config else we get an error when running npm install (or equivalents)
#
#   Cypress cannot write to the cache directory due to file permissions
#   Failed to access /root/.cache/Cypress:
#
# https://github.com/cypress-io/cypress/issues/3081
# https://stackoverflow.com/questions/55151786/getting-error-eacces-permission-denied-when-i-install-cypress
#
# Having checked Cypress' own Dockerfile files we could see they use both this and setting
# `npm_config_unsafe_perm true`. However, our tests confirmed we just need to set the user in npm's config and then the
# error goes away
RUN npm config -g set user $(whoami)

# Copy the project into the image. .dockerignore controls which files actually get copied in.
COPY . .

# Install the project dependencies and then run `cypress verify`. This avoids having to wait for Cypress to run its
# verification process each time you start a new container.
RUN npm ci && \
  npx cypress verify

CMD ["npm", "run", "cy:run:docker"]

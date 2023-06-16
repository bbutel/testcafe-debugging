# Stage 0, Based on Node.js, build and compile usefull librairies

ARG NODE_VERSION=16
ARG OS_VERSION=bullseye
ARG DEST_REPO="/e2etests"
ARG SRC_TESTCAFE_REPO="."
ARG SRC_DOCKERFILES_REPO="./docker"

FROM node:${NODE_VERSION}-${OS_VERSION}  as build-stage

ARG DEST_REPO
ARG SRC_TESTCAFE_REPO

WORKDIR ${DEST_REPO}

COPY ${SRC_TESTCAFE_REPO}/package.json ${DEST_REPO}/
COPY ${SRC_TESTCAFE_REPO}/yarn.lock ${DEST_REPO}/
COPY ${SRC_TESTCAFE_REPO}/.npmrc ${DEST_REPO}/

ENV NODE_ENV production
RUN yarn ci --omit=dev

# Stage 1, Base on Node.js, compiled testing application and all test source files

FROM node:${NODE_VERSION}-${OS_VERSION} as prod

ARG DEST_REPO
ARG SRC_TESTCAFE_REPO
ARG SRC_DOCKERFILES_REPO

ENV DEBIAN_FRONTEND="noninteractive"

RUN adduser --disabled-password --gecos "" --force-badname testrunner 

#============================================
# Google Chrome
#============================================
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
    jq \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR ${DEST_REPO}
RUN chown testrunner: ${DEST_REPO}

COPY --from=build-stage --chown=testrunner: ${DEST_REPO}/ ${DEST_REPO}
COPY --chown=testrunner: ${SRC_DOCKERFILES_REPO}/docker-cmd.sh /usr/local/bin/docker-cmd
COPY --chown=testrunner: ${SRC_TESTCAFE_REPO}/src ${DEST_REPO}/src
COPY --chown=testrunner: ${SRC_TESTCAFE_REPO}/.testcaferc.js ${DEST_REPO}/.testcaferc.js
COPY --chown=testrunner: ${SRC_TESTCAFE_REPO}/tsconfig.json ${DEST_REPO}/tsconfig.json

RUN chmod +x /usr/local/bin/docker-cmd

USER testrunner

RUN touch ${DEST_REPO}/.env

CMD ["docker-cmd"]
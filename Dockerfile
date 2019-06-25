FROM openjdk:8-jre-slim
FROM node:12.4.0-alpine

ENV SONAR_SCANNER_VERSION 3.3.0.1492
ENV SONAR_OPTS ''

RUN apt-get update && apt-get install -y wget git openssh-client
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip
RUN apt-get remove -y wget && apt-get purge
RUN apt-get install unzip
RUN unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip

RUN ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/bin/sonar-scanner
RUN chmod +x /usr/bin/sonar-scanner
RUN node -v

VOLUME /project
WORKDIR /project

ADD run-sonar.sh /usr/bin/run-sonar
RUN chmod +x /usr/bin/run-sonar

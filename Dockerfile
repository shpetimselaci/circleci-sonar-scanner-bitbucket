FROM openjdk:8-jre-slim

ENV SONAR_SCANNER_VERSION 3.3.0.1492
ENV SONAR_OPTS ''

RUN apt-get update && apt-get install -y wget git openssh-client
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip
RUN apt-get install unzip
RUN unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip
RUN wget http://nodejs.org/dist/v10.6.0/node-v10.6.0.tar.gz     
RUN cd node-v0.6.0
RUN ./configure
RUN make
RUN make install
RUN node -v
RUN apt-get remove -y wget && apt-get purge
RUN ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/bin/sonar-scanner
RUN chmod +x /usr/bin/sonar-scanner

VOLUME /project
WORKDIR /project

ADD run-sonar.sh /usr/bin/run-sonar
RUN chmod +x /usr/bin/run-sonar

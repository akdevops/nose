FROM jenkins/inbound-agent:latest-jdk11
USER root
RUN set -eux && \
 cd && \
 apt-get --quiet --quiet update && \
 apt-get --quiet --quiet upgrade --assume-yes && \
 apt-get --quiet --quiet install --assume-yes \
 curl \
 grep sed unzip nodejs npm
 
User jenkins
RUN mkdir -p scanner
wORKDIR scanner

RUN set -x &&\
 curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.0.0.1744-linux.zip &&\
 unzip sonarscanner.zip &&\
 rm sonarscanner.zip  &&\
 rm sonar-scanner-4.0.0.1744-linux/jre -rf &&\
 # ensure Sonar uses the provided Java for musl instead of a borked glibc one
 sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /home/jenkins/scanner/sonar-scanner-4.0.0.1744-linux/bin/sonar-scanner
 
ENV SONAR_RUNNER_HOME=/home/jenkins/scanner/sonar-scanner-4.0.0.1744-linux/bin
ENV PATH $PATH:/home/jenkins/scanner/sonar-scanner-4.0.0.1744-linux/bin

RUN mkdir -p app
wORKDIR app
COPY *  app/

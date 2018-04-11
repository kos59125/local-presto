FROM  ubuntu

USER  root

##
## variables
##
ARG  PRESTO_VERSION=0.198

##
## install dependencies
##
ADD  files/pom.xml pom.xml

RUN  apt-get -qq update \
   && apt-get -q install --no-install-recommends -y less python openjdk-8-jdk maven \
   # presto server
   && mkdir -p /opt/presto /opt/presto/data /opt/presto/etc /opt/presto/etc/catalog \
   && mvn -q dependency:copy-dependencies -DoutputDirectory=. -DincludeArtifactIds=presto-server \
   && tar xfz presto-server-${PRESTO_VERSION}.tar.gz -C /opt/presto --strip-components=1 \
   && rm -f presto-server-${PRESTO_VERSION}.tar.gz \
   # presto cli
   && mvn -q dependency:copy-dependencies -DoutputDirectory=/opt/presto/bin/ -DincludeArtifactIds=presto-cli -Dclassifier=executable \
   && chmod a+x /opt/presto/bin/presto-cli-${PRESTO_VERSION}-executable.jar \
   && ln -sf presto-cli-${PRESTO_VERSION}-executable.jar /opt/presto/bin/presto \
   && rm -rf /root/.m2 \
   && rm -f pom.xml \
   # user settings
   && touch /opt/presto/.presto_history \
   && useradd --system --home-dir /opt/presto --no-create-home presto \
   && chown -R presto:presto /opt/presto \
   # clean up
   && apt-get -q remove -y maven \
   && apt-get -qq clean \
   && rm -rf /var/lib/apt/lists/*

ADD  files/entrypoint.sh /opt/presto/
RUN  chmod a+x /opt/presto/entrypoint.sh

##
## initialize
##
USER  presto
WORKDIR  /opt/presto

ENV  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre \
   PATH=/opt/presto/bin:/usr/lib/jvm/java-8-openjdk-amd64/jre/bin:$PATH

COPY  files/config/*.* /opt/presto/etc/
COPY  files/catalog/*.* /opt/presto/etc/catalog/

# presto server ports
EXPOSE  8080

# entrypoint
ENTRYPOINT  ["/opt/presto/entrypoint.sh"]

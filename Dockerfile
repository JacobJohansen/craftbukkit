FROM ubuntu:14.04

RUN apt-get update \
        && apt-get install -y vim \
        && apt-get install -y software-properties-common \
        && apt-get install -y curl

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# set environment
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN mkdir -p /craftbukkit
RUN curl http://tcpr.ca/files/spigot/spigot-latest.jar -o /craftbukkit/craftbukkit.jar

RUN mkdir -p /craftbukkit/plugins
COPY mcMMO.jar /craftbukkit/plugins/mcMMO.jar
COPY Vault-1.6.6.jar /craftbukkit/plugins/Vault.jar
COPY permissionsex-bukkit-2.0-SNAPSHOT-shaded.jar /craftbukkit/plugins/permissionsex.jar
COPY EssentialsX-2.0.1.jar /craftbukkit/plugins/EssentialsX.jar
COPY EssentialsXChat-2.0.1.jar /craftbukkit/plugins/EssentialsXChat.jar
COPY EssentialsXProtect-2.0.1.jar /craftbukkit/plugins/EssentialsXProtect.jar
COPY EssentialsXSpawn-2.0.1.jar /craftbukkit/plugins/EssentialsXSpawn.jar
RUN mkdir -p /craftbukkit/plugins/PermissionsEx
COPY src/pexConfig.yml /craftbukkit/plugins/PermissionsEx/config.yml
COPY src/permissions.yml /craftbukkit/plugins/PermissionsEx/permissions.yml
RUN echo "#!/bin/bash\ncd /craftbukkit/\njava -Xmx1024M -jar craftbukkit.jar -o true" > /usr/local/bin/craftbukkit
RUN chmod +x /usr/local/bin/craftbukkit

COPY src/ /craftbukkit/

EXPOSE 25565:25565

ENTRYPOINT craftbukkit

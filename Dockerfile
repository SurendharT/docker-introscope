FROM jeanblanchard/busybox-java:7

MAINTAINER sieglst@googlemail.com / stefan.siegl@novatec-gmbh.de

WORKDIR /opt/introscope-install

### For new Introscope version you must change the following variables
ENV INTROSCOPE_VERSION=9.6.0.0
### End for new Introscope version

ENV INTROSCOPE_HOME=/root/Introscope
ENV INTROSCOPE_BIN=introscope${INTROSCOPE_VERSION}otherUnix.jar
ENV INTROSCOPE_OSGI=osgiPackages.v${INTROSCOPE_VERSION}.unix.tar
ENV HEAP_XMX **DEFAULT**

ADD SampleResponseFile.Introscope.txt /opt/introscope-install/SampleResponseFile.Introscope.txt
ADD ${INTROSCOPE_BIN} /opt/introscope-install/${INTROSCOPE_BIN}
# I learned the hard way that ADDing a tar file will extract it - not what we want here. 
COPY ${INTROSCOPE_OSGI} /opt/introscope-install/${INTROSCOPE_OSGI}
ADD eula-osgi/eula.txt /opt/introscope-install/eula-osgi/eula.txt
ADD eula-introscope/ca-eula.txt /opt/introscope-install/eula-introscope/ca-eula.txt
ADD startup.sh /opt/introscope-install/startup.sh
ADD addons /opt/introscope-install/addons

RUN chmod +x startup.sh

# run the installation of the enterprise manager
RUN java -jar ${INTROSCOPE_BIN} -f SampleResponseFile.Introscope.txt

# Port used by Enterprise Manager to listen for incoming connections.
EXPOSE 5001
# Port used by Enterprise Manager to serve web applications.
EXPOSE 8081


VOLUME ${INTROSCOPE_HOME}/data
VOLUME ${INTROSCOPE_HOME}/traces

CMD /opt/introscope-install/startup.sh
FROM       hasufell/gentoo-java:latest
MAINTAINER Julian Ospald <hasufell@gentoo.org>

##### PACKAGE INSTALLATION #####

ENV TOMCAT_VER=8 \
	ECLIPSE_ECJ_VER=4.4 \
	TOMCAT_SERVLET_VER=3.1 \
	CATALINA_HOME=/usr/share/tomcat-8 \
	CATALINA_BASE=/var/lib/tomcat-8 \
	CATALINA_TMPDIR=/var/tmp/tomcat-8 \
	CATALINA_USER=tomcat \
	CATALINA_GROUP=tomcat

# copy paludis config
COPY ./config/paludis /etc/paludis
RUN sed -i \
		-e "s#@ECLIPSE_ECJ_VER@#${ECLIPSE_ECJ_VER}#" \
		-e "s#@TOMCAT_SERVLET_VER@#${TOMCAT_SERVLET_VER}#" \
		-e "s#@TOMCAT_VER@#${TOMCAT_VER}#" \
		/etc/paludis/sets/tomcat.conf

# update world with our USE flags
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x

# install tomcat set
RUN chgrp paludisbuild /dev/tty && cave resolve -c tomcat -x

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################

RUN mkdir -p /var/log/tomcat-${TOMCAT_VER} /var/tmp/tomcat-${TOMCAT_VER}

# fix classpath in catalina.sh
RUN sed -i \
	-e 's/CLASSPATH=`java-config/CLASSPATH=`java-config --with-dependencies/' \
	/usr/share/tomcat-${TOMCAT_VER}/bin/catalina.sh

# default tomcat port
EXPOSE 8080

CMD exec /usr/share/tomcat-${TOMCAT_VER}/bin/catalina.sh run

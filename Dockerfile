FROM       hasufell/gentoo-java:latest
MAINTAINER Julian Ospald <hasufell@gentoo.org>

##### PACKAGE INSTALLATION #####

ENV TOMCAT_VER=8
ENV ECLIPSE_ECJ_VER=4.4
ENV TOMCAT_SERVLET_VER=3.1

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

# install tools set
RUN chgrp paludisbuild /dev/tty && cave resolve -c tools -x

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################


# set up tomcat
RUN /usr/share/tomcat-8/gentoo/tomcat-instance-manager.bash --create

# default tomcat port
EXPOSE 8080

# :/
# make sure this is what we get in /etc/init.d/tomcat-*
CMD "$(java-config -o home)"/bin/java \
	-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
	-Djava.util.logging.config.file=/var/lib/tomcat-${TOMCAT_VER}/conf/logging.properties \
	-Dcatalina.base=/var/lib/tomcat-${TOMCAT_VER} \
	-Dcatalina.home=/usr/share/tomcat-${TOMCAT_VER} \
	-Djava.io.tmpdir=/var/tmp/tomcat-${TOMCAT_VER} \
	-classpath /usr/share/tomcat-${TOMCAT_VER}/bin/bootstrap.jar:/usr/share/tomcat-${TOMCAT_VER}/bin/tomcat-juli.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/annotations-api.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/catalina-ant.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/catalina-ha.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/catalina-storeconfig.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/catalina-tribes.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/catalina.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/jasper-el.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/jasper.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-api.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-coyote.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-dbcp.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-i18n-es.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-i18n-fr.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-i18n-ja.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-jni.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-util-scan.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-util.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/tomcat-websocket.jar:/usr/share/tomcat-${TOMCAT_VER}/lib/websocket-api.jar:/usr/share/eclipse-ecj-${ECLIPSE_ECJ_VER}/lib/ecj.jar:/usr/share/tomcat-servlet-api-${TOMCAT_SERVLET_VER}/lib/el-api.jar:/usr/share/tomcat-servlet-api-${TOMCAT_SERVLET_VER}/lib/jsp-api.jar:/usr/share/tomcat-servlet-api-${TOMCAT_SERVLET_VER}/lib/servlet-api.jar org.apache.catalina.startup.Bootstrap \
	start

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

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################

# fix tomcat config creation script
COPY ./tomcat-im-script.patch /tomcat-im-script.patch
RUN cd /usr/share/tomcat-${TOMCAT_VER}/gentoo && \
	patch -p0 -i /tomcat-im-script.patch

# default tomcat port
EXPOSE 8080

CMD /usr/share/tomcat-${TOMCAT_VER}/bin/catalina.sh run

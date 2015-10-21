## Running

First set up tomcat:
```sh
docker run -ti \
	-v <host-folder>:/var/lib/tomcat-8 \
	-v <host-folder>:/etc/tomcat-8 \
	hasufell/gentoo-tomcat \
	/usr/share/tomcat-8/gentoo/tomcat-instance-manager.bash --create
```

Then start tomcat:
```sh
docker run -ti -d \
	-v <host-folder>:/var/lib/tomcat-8 \
	-v <host-folder>:/etc/tomcat-8 \
	-p 8080:8080 \
	hasufell/gentoo-tomcat
```

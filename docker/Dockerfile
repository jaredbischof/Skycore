# Skycore factory - a compilation container

#FROM ubuntu:14.04
FROM skyport/awe

RUN apt-get update ; apt-get install -y \
	#golang \
	#git \
	build-essential # needed for static compilation


#AWE source
RUN mkdir -p /gopath/src/github.com/MG-RAST ; \
	cd /gopath/src/github.com/MG-RAST && \
	rm -rf AWE ; \
	git clone -b master https://github.com/wgerlach/AWE.git

RUN mkdir -p /gopath/src/github.com/MG-RAST ; \
	cd /gopath/src/github.com/MG-RAST && \
	rm -rf go-dockerclient ; \
	git clone -b develop https://github.com/MG-RAST/go-dockerclient.git

RUN mkdir -p /gopath/src/github.com/wgerlach ; \
	cd /gopath/src/github.com/wgerlach && \
	git clone -b master https://github.com/wgerlach/Skycore.git

ENV GOPATH /gopath/

# compile.sh script for 
RUN echo '#!/bin/bash' > /compile.sh ; \
	echo 'export GOPATH=/gopath/ ; export CGO_ENABLED=0 ; go get -a -v github.com/wgerlach/Skycore/skycore' >> /compile.sh ; \
	chmod +x /compile.sh


### build container
# docker build --tag skycore/factory:latest .

### use container to compile and get binary:
# mkdir -p ~/skycore_bin
# docker run -t -i --name sky_fac -v ~/skycore_bin:/gopath/bin skycore/factory:latest /compile.sh
# if you plan to compile multiple times with latest code:
# docker run -t -i --name sky_fac -v ~/skycore_bin:/gopath/bin skycore/factory:latest bash -c "cd /gopath/src/github.com/wgerlach/Skycore && git pull && /compile.sh"
# docker start sky_fac

### skycore execution within container
# container will need access to docker socket
# mkdir -p ~/skycore_bin
# docker run -t -i -v /var/run/docker.sock:/var/run/docker.sock --name sky_fac -v ~/skycore_bin:/gopath/bin skycore/factory:latest bash



FROM ubuntu:18.10

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential git cmake sudo vim \
	bison flex python-dev \
	autoconf libtool pkg-config libssl-dev \
	net-tools wget mongodb-clients iputils-ping && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.12.0/mongo-c-driver-1.12.0.tar.gz && \
	tar xzf mongo-c-driver-1.12.0.tar.gz && \
	cd mongo-c-driver-1.12.0 && \
    mkdir cmake-build && cd cmake-build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. && \
    make -j 4 && sudo make install && cd .. \
    && rm -rf /opt/*

RUN wget https://github.com/mongodb/mongo-cxx-driver/archive/r3.3.1.tar.gz && \
	tar -xzf r3.3.1.tar.gz && cd mongo-cxx-driver-r3.3.1/build && \
	cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
	sudo make -j 2 && sudo make install && cd .. \
  && rm -rf /opt/*

COPY mangrove-build.patch /opt/
RUN git clone -b master https://github.com/aospan/mangrove.git && \
	cd mangrove && git apply /opt/mangrove-build.patch && \
	cd build && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
	make -j 2 && sudo make install && cd .. \
  && rm -rf /opt/*

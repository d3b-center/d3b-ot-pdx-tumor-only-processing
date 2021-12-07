FROM ubuntu:16.04
LABEL maintainer="Miguel Brown (brownm28@chop.edu)"

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y g++ cmake libboost-all-dev pandoc zlib1g-dev libbz2-dev libsqlite3-dev git
RUN git clone https://github.com/data61/gossamer && cd gossamer && mkdir build && cd build && cmake -DBUILD_tests=OFF .. && make && make install
RUN apt install -y pigz

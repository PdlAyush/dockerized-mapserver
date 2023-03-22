FROM ayushpdl/csp_base:latest


ADD meta.map /storage/mapserver-datasets

WORKDIR /tmp

#Copying the shell file which will download the dataset
ADD datas.sh /tmp

RUN apt-get update \
    && apt-get -y install curl \
    && apt-get -y install unzip \
    && rm -rf /var/lib/apt/lists/*;

RUN ./datas.sh
RUN rm -rf /tmp/*
WORKDIR /storage/mapserver-datasets

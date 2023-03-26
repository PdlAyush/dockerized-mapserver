FROM ayushpdl/csp_base:latest

COPY Example-Datasets /Example-Datasets
WORKDIR /tmp

#Copying the shell file which will download the dataset
ADD datas.sh /tmp

RUN apt-get update \
    && apt-get -y install curl \
                curl \
                unzip \
                gdal-bin \
    && rm -rf /var/lib/apt/lists/*;

RUN ./datas.sh
RUN rm -rf /tmp/*
RUN rm -rf /Example-Datasets/*
WORKDIR /storage/mapserver-datasets

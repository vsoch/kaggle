FROM continuumio/miniconda3
MAINTAINER vsochat@stanford.edu

# docker build -t vanessa/kaggle .

RUN apt-get update
RUN apt-get -y install apt-utils wget git

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ENV PATH /opt/conda/bin:$PATH
RUN mkdir /code

RUN /opt/conda/bin/pip install --upgrade pip && \
    /opt/conda/bin/pip install kaggle && \
    /opt/conda/bin/pip install ipython

ADD . /code
WORKDIR /code

# Finish up
RUN chmod u+x /code/create_dataset.py && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

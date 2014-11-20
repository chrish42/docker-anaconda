FROM debian:wheezy
MAINTAINER Christian Hudon <chrish@pianocktail.org>

ENV LANG C.UTF-8
ENV PATH /opt/anaconda/bin:$PATH
ENV ANACONDA_VERSION 2.1.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y bzip2 curl && rm -rf /var/lib/apt/lists/*
RUN curl -o /tmp/anaconda.sh http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.1.0-Linux-x86_64.sh && bash /tmp/anaconda.sh -b -p /opt/anaconda && rm /tmp/anaconda.sh

RUN useradd -mU user
USER user

ONBUILD USER root
ONBUILD RUN useradd --system --user-group --home-dir /app app
ONBUILD RUN mkdir /app
ONBUILD WORKDIR /app
ONBUILD COPY conda_requirements.txt requirements.txt /app/
ONBUILD RUN conda create -p /env --yes --file /app/conda_requirements.txt pip
ONBUILD ENV PATH /env/bin:$PATH
ONBUILD RUN pip install -r /app/requirements.txt
ONBUILD USER app

ENTRYPOINT ["python"]

# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

FROM ubuntu:12.04

RUN apt-get update; \
    apt-get install -y git-core build-essential python-dev \
    libevent1-dev python-openssl liblzma-dev wget; \
    rm /var/lib/apt/lists/*_*
RUN cd /tmp; wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
RUN cd /tmp; python ez_setup.py; easy_install pip; \
    rm ez_setup.py

#ADD ./.pip /.pip
#RUN cd /docker-registry && pip install -r requirements.txt
RUN pip install pbr -i http://mirrors.aliyun.com/pypi/simple/
RUN pip install d2to1 -i http://mirrors.aliyun.com/pypi/simple/

ADD ./requirements.txt /tmp/requirements.txt
RUN cd /tmp && pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/

ADD . /docker-registry
#RUN cd /docker-registry && pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/

ADD ./config/boto.cfg /etc/boto.cfg

EXPOSE 5000

#RUN mkdir -p /var/docker/prod
VOLUME ["/var/docker/prod"]

CMD cd /docker-registry && ./setup-configs.sh && ./run_prod.sh

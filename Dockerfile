FROM nvidia/cuda:8.0-cudnn5-devel

MAINTAINER Vladimir Ivashkin illusionww@gmail.com

ENV LANGUAGE en_US
ENV LC_ALL ru_RU.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get update && \
    apt-get install -y language-pack-ru && \
    rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure locales

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get -y upgrade

RUN apt-get install -yqq build-essential cmake wget unzip git vim \
    python python-pip python-dev python3 python3-pip python3-dev \
    gfortran libatlas-base-dev libatlas-dev libatlas3-base libhdf5-dev \
    libfreetype6-dev libpng12-dev pkg-config libxml2-dev libxslt-dev swig \
    libboost-program-options-dev zlib1g-dev libboost-python-dev vowpal-wabbit

RUN pip install -U pip scipy numpy cython && \
    pip install -U sklearn jupyter pandas xlrd matplotlib seaborn tqdm \
                    joblib h5py theano tensorflow keras lasagne nolearn \
                    sexpdata vowpalwabbit nltk gensim pymorphy2 pymorphy2-dicts-ru \
                    opencv-python pillow gym[all] && \
    python -m ipykernel.kernelspec

RUN pip3 install -U pip scipy numpy cython && \
    pip3 install -U sklearn jupyter pandas xlrd matplotlib seaborn tqdm \
                    joblib h5py theano tensorflow keras lasagne nolearn \
                    sexpdata vowpalwabbit nltk gensim pymorphy2 pymorphy2-dicts-ru \
                    opencv-python pillow gym[all] && \
    python3 -m ipykernel.kernelspec

RUN git clone --recursive https://github.com/dmlc/xgboost /tmp/xgboost && \
    cd /tmp/xgboost && \
    make && \
    cd python-package && \
    python setup.py install && \
    python3 setup.py install

EXPOSE 8888
WORKDIR /notebook

ADD jupyter_notebook_config.py /jupyter/jupyter_notebook_config.py
COPY notebook.sh /notebook.sh

ENV JUPYTER_CONFIG_DIR="/jupyter"

CMD ["/notebook.sh"]

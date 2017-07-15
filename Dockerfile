FROM nvidia/cuda:8.0-cudnn5-devel

MAINTAINER Vladimir Ivashkin illusionww@gmail.com

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential cmake gcc apt-utils python3 python3-pip python3-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget unzip git vim nano \
    gfortran libatlas-base-dev libatlas-dev libatlas3-base libhdf5-dev \
    libfreetype6-dev libpng12-dev pkg-config libxml2-dev libxslt-dev \
    libjpeg-dev xvfb libav-tools xorg-dev libsdl2-dev swig python-opencv \
    libboost-program-options-dev zlib1g-dev libboost-all-dev libboost-python-dev

RUN pip3 install -U pip cython joblib vowpalwabbit tqdm && \
    pip3 install -U jupyter scipy numpy scikit-learn pandas xlrd matplotlib seaborn \
                    Pillow scikit-image \
                    nltk gensim pymorphy2 pymorphy2-dicts-ru && \
    python3 -m ipykernel.kernelspec

RUN pip3 install -U https://github.com/Theano/Theano/archive/master.zip && \
    pip3 install -U https://github.com/Lasagne/Lasagne/archive/master.zip && \
    pip3 install -U https://github.com/yandexdataschool/AgentNet/archive/master.zip && \
    pip3 install -U tensorflow-gpu keras h5py gym[all]

RUN git clone --recursive https://github.com/dmlc/xgboost /tmp/xgboost && \
    cd /tmp/xgboost && \
    make && \
    cd python-package && \
    python3 setup.py install

EXPOSE 8888 6006
WORKDIR /notebook

ADD jupyter_notebook_config.py /jupyter/jupyter_notebook_config.py
COPY notebook.sh /notebook.sh

ENV JUPYTER_CONFIG_DIR="/jupyter"

CMD ["/notebook.sh"]

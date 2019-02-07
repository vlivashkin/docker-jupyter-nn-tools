FROM nvidia/cuda:10.0-devel-ubuntu18.04

MAINTAINER Vladimir Ivashkin illusionww@gmail.com

ENV CUDNN_VERSION 7.4.2.24

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
        build-essential cmake gcc apt-utils python3 python3-pip python3-dev \
        wget unzip git vim nano \
        gfortran libatlas-base-dev libatlas3-base libhdf5-dev \
        libfreetype6-dev pkg-config libxml2-dev libxslt-dev \
        libjpeg-dev xvfb xorg-dev libsdl2-dev swig \
        libboost-program-options-dev zlib1g-dev libboost-all-dev libboost-python-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install -U pip && \
    pip3 install -U cython joblib vowpalwabbit tqdm jsonlines beautifulsoup4 && \
    pip3 install -U jupyter scipy numpy scikit-learn pandas xlrd pandas-profiling \
                    matplotlib plotly seaborn Pillow scikit-image imgaug opencv-python opencv-contrib-python \
                    nltk gensim pymorphy2[fast] pymorphy2-dicts-ru h5py xgboost catboost \
                    tensorflow-gpu keras torch torchvision tensorboardX && \
    pip3 install -U html5lib==0.999999999 && \
    python3 -m ipykernel.kernelspec && \
    jupyter nbextension enable --py --sys-prefix widgetsnbextension

ADD jupyter_notebook_config.py /jupyter/jupyter_notebook_config.py
ENV JUPYTER_CONFIG_DIR="/jupyter"

WORKDIR /notebook
COPY notebook.sh /notebook.sh
CMD ["/notebook.sh"]

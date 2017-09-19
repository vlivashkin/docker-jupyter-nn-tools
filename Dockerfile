FROM nvidia/cuda:8.0-cudnn6-devel

MAINTAINER Vladimir Ivashkin illusionww@gmail.com

RUN apt-get clean && apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential cmake gcc apt-utils python3 python3-pip python3-dev && \
    apt-get install -y wget unzip git vim nano \
    gfortran libatlas-base-dev libatlas-dev libatlas3-base libhdf5-dev \
    libfreetype6-dev libpng12-dev pkg-config libxml2-dev libxslt-dev \
    libjpeg-dev xvfb libav-tools xorg-dev libsdl2-dev swig \
    libboost-program-options-dev zlib1g-dev libboost-all-dev libboost-python-dev
	

RUN apt-get install -y --no-install-recommends build-essential curl ca-certificates
RUN apt-get install -y --no-install-recommends cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y --no-install-recommends python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
RUN apt-get install -y --no-install-recommends ffmpeg x264

RUN curl -OL "https://github.com/opencv/opencv/archive/3.2.0.tar.gz"
RUN tar -zxvf 3.2.0.tar.gz && rm -rf 3.2.0.tar.gz
WORKDIR opencv-3.2.0/
RUN rm -rf build/ && mkdir build/
WORKDIR build/

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D PYTHON3_EXECUTABLE=/usr/bin/python3 -D PYTHON_INCLUDE_DIR=/usr/include/python3.5 -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.5m -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ ..
RUN make -j$(($(nproc) + 1))
RUN make install

RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig

WORKDIR ../../
RUN rm -rf opencv-3.2.0/


RUN pip3 install -U pip cython joblib vowpalwabbit tqdm html5lib==0.999999999 && \
    pip3 install -U jupyter scipy numpy scikit-learn pandas xlrd matplotlib plotly seaborn \
                    Pillow scikit-image imgaug \
                    nltk gensim pymorphy2 pymorphy2-dicts-ru \
					theano tensorflow-gpu keras h5py gym[all] \
					xgboost catboost && \
    python3 -m ipykernel.kernelspec && \
	jupyter nbextension enable --py --sys-prefix widgetsnbextension

RUN pip3 install -U https://github.com/Lasagne/Lasagne/archive/master.zip && \
    pip3 install -U https://github.com/yandexdataschool/AgentNet/archive/master.zip


EXPOSE 8888 6006

ADD jupyter_notebook_config.py /jupyter/jupyter_notebook_config.py
ENV JUPYTER_CONFIG_DIR="/jupyter"

WORKDIR /notebook
COPY notebook.sh /notebook.sh
CMD ["/notebook.sh"]

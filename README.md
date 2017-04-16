# docker-jupyter-nn-tools

This is the dockerfile with all ML stuff I use

## Build from Scratch

    git clone https://github.com/illusionww/docker-jupyter-nn-tools
    cd docker-jupyter-nn-tools
    docker build -t illusionww/jupyter-nn-tools .

## Run

    nvidia-docker run -ti --rm \
        -v `pwd`:/notebook \
        -p 8888:8888 \
        illusionww/jupyter-nn-tools

More info (in source project)[https://github.com/windj007/docker-jupyter-keras-tools]
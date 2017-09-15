# docker-jupyter-nn-tools

This is the dockerfile with all ML stuff I use

## Build from Scratch

    git clone https://github.com/illusionww/docker-jupyter-nn-tools
    cd docker-jupyter-nn-tools
    sudo chmod -R 777 .
    sudo docker build -t illusionww/jupyter-nn-tools .

## Run

    nvidia-docker run -ti --rm \
        -v /home/<USER_NAME>/Documents:/notebook -v /data:/data\
        -p 8888:8888 -p 6006:6006 \
        illusionww/jupyter-nn-tools

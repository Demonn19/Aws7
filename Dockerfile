FROM ubuntu:20.04

RUN mkdir /bot && chmod 777 /bot
WORKDIR /bot

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update && \
    apt-get install -y git aria2 qbittorrent-nox bash xz-utils wget curl pv jq python3.10 python3-dev python3-pip mediainfo libssl-dev ca-certificates && \
    update-ca-certificates && \
    wget https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n5.1-latest-linux64-gpl-5.1.tar.xz && \
    tar -xvf ffmpeg-n5.1-latest-linux64-gpl-5.1.tar.xz && \
    cp ffmpeg-n5.1-latest-linux64-gpl-5.1/bin/* /usr/bin && \
    rm -rf ffmpeg-n5.1-latest-linux64-gpl-5.1.tar.xz && \
    rm -rf ffmpeg-n5.1-latest-linux64-gpl-5.1 && \
    export PATH=$PATH:/usr/local/bin && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
RUN conda init bash

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN /opt/conda/bin/conda create -y --name bot python=3.10 && \
    /opt/conda/bin/conda activate bot

COPY . .

RUN /opt/conda/bin/conda install -y -c conda-forge --name bot --file requirements.txt

CMD ["/bin/bash", "-c", "source activate bot && bash run.sh"]

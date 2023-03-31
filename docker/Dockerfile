FROM ubuntu:20.04

ENV TZ=Asia/Tokyo
ENV LANG C.UTF-8
ENV LANGUAGE en_US
ENV TERM xterm-256color

RUN set -e \
    && ln -sf bash /bin/sh

RUN set -e \
    && apt -y update \
    && apt -y dist-upgrade \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt -y install --no-install-recommends --no-install-suggests \
        autoconf \ 
        automake \
        bamtools \
        bcftools \
        ca-certificates \
        curl \
        default-jdk \
        g++ \
        gcc \
        gffread \
        git \
        gosu \
        less \
        libz-dev \
        make \
        perl \
        picard-tools \
        python3-dev \
        samtools \
        sudo \
        unzip \
        vim \
        wget \
    && apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -e \
    && ln -s python3 /usr/bin/python \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py \
    && pip install -U --no-cache-dir pip \
    && pip install --no-cache-dir \
        biopython \
        cutadapt \
        gff3tool \
        igv-notebook \
        jupyterlab \
        matplotlib \
        notebook \
        numpy \
        pandas \
        pillow \
        seaborn \
        scikit-learn \
        scipy \
        tqdm \
        xlrd

# FASTQC
RUN set -e \ 
    && wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip \
    && unzip -d /usr/local fastqc_v0.11.9.zip \
    && chmod +x /usr/local/FastQC/fastqc \
    && ln -s /usr/local/FastQC/fastqc /usr/local/bin \
    && rm -f fastqc_v0.11.9.zip

# Trimmomatic
RUN set -e \
    && wget https://github.com/timflutre/trimmomatic/archive/master.tar.gz \
    && tar xvf master.tar.gz -C /usr/local --remove-files \
    && mv /usr/local/trimmomatic-* /usr/local/trimmomatic \
    && cd /usr/local/trimmomatic \
    && make \
    && mkdir /usr/local/trimmomatic/bin \
    && echo '#!/usr/bin/env bash' > /usr/local/trimmomatic/bin/trimmomatic \
    && echo 'java -jar /usr/local/trimmomatic/classes/trimmomatic.jar ${@}' \
        >> /usr/local/trimmomatic/bin/trimmomatic \
    && chmod +x /usr/local/trimmomatic/bin/trimmomatic \
    && ln -s /usr/local/trimmomatic/bin/trimmomatic /usr/local/bin \
    && cd / \
    && rm -f master.tar.gz

# Bowtie
RUN set -e \
    && wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.3.1/bowtie-1.3.1-linux-x86_64.zip --no-check-certificate \
    && unzip bowtie-1.3.1-linux-x86_64.zip \
    && mv bowtie-1.3.1-linux-x86_64 /usr/local/bowtie \
    && rm bowtie-1.3.1-linux-x86_64.zip \
    && ln -s /usr/local/bowtie/bowtie /usr/local/bin \
    && ln -s /usr/local/bowtie/bowtie-build /usr/local/bin

# Bowtie2
RUN set -e \
    && wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.4.5/bowtie2-2.4.5-linux-x86_64.zip --no-check-certificate \
    && unzip bowtie2-2.4.5-linux-x86_64.zip \
    && mv bowtie2-2.4.5-linux-x86_64 /usr/local/bowtie2 \
    && rm bowtie2-2.4.5-linux-x86_64.zip \
    && ln -s /usr/local/bowtie2/bowtie2 /usr/local/bin \
    && ln -s /usr/local/bowtie2/bowtie2-build /usr/local/bin

# BWA
RUN set -e \
    && wget https://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.17.tar.bz2 \
    && tar xf bwa-0.7.17.tar.bz2 \
    && cd bwa-0.7.17 \
    && make \
    && cd .. \
    && mv bwa-0.7.17 /usr/local/bwa \
    && ln -s /usr/local/bwa/bwa /usr/local/bin \
    && rm -f bwa-0.7.17.tar.bz2

# SubRead
RUN set -e \
    && wget https://sourceforge.net/projects/subread/files/subread-2.0.3/subread-2.0.3-Linux-x86_64.tar.gz --no-check-certificate \
    && tar xvfz subread-2.0.3-Linux-x86_64.tar.gz \
    && mv subread-2.0.3-Linux-x86_64 /usr/local/subread \
    && rm -f subread-2.0.3-Linux-x86_64.tar.gz \
    && ls -F /usr/local/subread/bin/ | grep -v / | sed s/\*$//g | xargs -I{} ln -s /usr/local/subread/bin/{} /usr/local/bin

# STAR
RUN set -e \
    && wget https://github.com/alexdobin/STAR/archive/refs/tags/2.7.10a.tar.gz \
    && tar xvzf 2.7.10a.tar.gz \
    && cd STAR-2.7.10a/source \
    && make \
    && cd / \
    && mv STAR-2.7.10a /usr/local/STAR \
    && ln -s /usr/local/STAR/source/STAR /usr/local/bin \
    && rm -f 2.7.10a.tar.gz

# sRNAbench
RUN set -e \
    && git clone https://github.com/bioinfoUGR/sRNAtoolbox.git /usr/local/sRNAtoolbox \
    && mkdir /usr/local/sRNAtoolbox/bin \
    && echo '#!/usr/bin/env bash' > /usr/local/sRNAtoolbox/bin/sRNAbench \
    && echo 'java -jar /usr/local/sRNAtoolbox/sRNAbench.jar ${@}' \
        >> /usr/local/sRNAtoolbox/bin/sRNAbench \
    && chmod +x /usr/local/sRNAtoolbox/bin/sRNAbench \
    && ln -s /usr/local/sRNAtoolbox/bin/sRNAbench /usr/local/bin

# seqtk
RUN set -e \
    && git clone https://github.com/lh3/seqtk.git \
    && cd seqtk \
    && make \
    && cp seqtk /usr/local/bin/ \
    && cd .. \
    && rm -rf seqtk

# fastx-toolkit
RUN set -e \
    && wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 \
    && mkdir /usr/local/fastx_toolkit \
    && tar -xjf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 -C /usr/local/fastx_toolkit/ \
    && rm -f fastx_toolkit* \
    && ls /usr/local/fastx_toolkit/bin/* | xargs -I{} ln -s {} /usr/local/bin

# seqkit
RUN set -e \
    && wget https://github.com/shenwei356/seqkit/releases/download/v2.3.1/seqkit_linux_amd64.tar.gz \
    && tar -zxvf seqkit_linux_amd64.tar.gz -C /usr/local/bin/ \
    && rm -f seqkit_linux_amd64.tar.gz

# PRINSEQ
RUN set -e \
    && wget https://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz \
    && tar -zxvf prinseq-lite-0.20.4.tar.gz \
    && cp prinseq-lite-0.20.4/prinseq-lite.pl /usr/local/bin/ \
    && chmod +x /usr/local/bin/prinseq-lite.pl \
    && rm -rf prinseq-lite-*

# GATK
RUN set -e \
    && wget https://github.com/broadinstitute/gatk/releases/download/4.3.0.0/gatk-4.3.0.0.zip \
    && unzip gatk-4.3.0.0.zip \
    && mv gatk-4.3.0.0 /usr/local/gatk \
    && ln -s /usr/local/gatk/gatk /usr/local/bin \
    && rm -rf gatk-4.3.0.0.zip

# ezcount
RUN set -e \
    && git clone https://gitlab.com/BioAlgo/miR-pipe.git \
    && cd miR-pipe \
    && make \
    && mkdir -p /usr/local/share/man/man1 \
    && make install \
    && cd .. \
    && rm -rf miR-pipe

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 8888 


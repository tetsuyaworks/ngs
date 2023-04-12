#!/bin/bash

REF_DIR=~/ref
IDX_NAME=GRCh38

FASTA_PATH=https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz
GFF_PATH=https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.gff.gz

idx_path=$REF_DIR/$IDX_NAME
fasta_path=$REF_DIR/`basename $FASTA_PATH`
gff_path=$REF_DIR/`basename $GFF_PATH`

if [ ! -d $REF_DIR ];then
    mkdir $REF_DIR
fi

if [[ -e "$idx_path.bwt" && -e $gff_path ]]; then
    echo "index file and gff file are already exists"
    exit 0
fi

if [ ! -e $fasta_path ]; then
    wget -P $REF_DIR $FASTA_PATH 
fi

if [ ! -e $gff_path ]; then
    wget -P $REF_DIR $GFF_PATH 
fi

bwa index -p $idx_path $fasta_path 

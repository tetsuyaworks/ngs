#!/bin/bash

REF_DIR=~/ref
DB_NAME=mirna.db

FASTA_PATH=https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/p14/hg38.p14.fa.gz
GFF_PATH=https://www.mirbase.org/ftp/CURRENT/genomes/hsa.gff3

db_path=$REF_DIR/$DB_NAME
fasta_path=$REF_DIR/`basename $FASTA_PATH`
gff_path=$REF_DIR/`basename $GFF_PATH`


if [ ! -d $REF_DIR ];then
    mkdir $REF_DIR
fi

if [ -e $db_path ]; then
    echo "DB file ($db_path) is already exists"
    exit 0
fi

if [ ! -e $fasta_path ]; then
    wget -P $REF_DIR $FASTA_PATH 
fi

if [ ! -e $gff_path ]; then
    wget -P $REF_DIR $GFF_PATH 
fi

ezcount -g $gff_path -r $fasta_path -d $db_path
grep ";Y;$" $db_path | awk '{print $1";"$2";"$3";;;;Y;"}' FS=";" > tmp.db
mv tmp.db $db_path
rm $fasta_path $gff_path

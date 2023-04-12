#!/bin/bash

IDX_PATH=~/ref/GRCh38
GFF_PATH=~/ref/GRCh38_latest_genomic.gff.gz
USE_CPU=20
ADAPTER=AACTGTAGGCACCATCAAT
TMP_DIR=.

INPUT_FQ=$1
OUTPUT_TXT=$2


if [[ "$INPUT_FQ" = "" || "$OUTPUT_TXT" = "" ]] ; then
    echo "USAGE: ./mirna_pipeline-count.sh input.fq output.txt"
    echo "  input.fq   : target input fastq file (gz)"
    echo "  output.txt : result miRNA count data (tsv)"
    exit 1
fi

tmpdir=`mktemp -d`
trap "rm -rfv $tmpdir" EXIT

cutadapt -j $USE_CPU -a $ADAPTER -o $tmpdir/1.fq $INPUT_FQ
trimmomatic SE -threads $USE_CPU -phred33 $tmpdir/1.fq $tmpdir/2.fq LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:30
bwa mem -t $USE_CPU $IDX_PATH $tmpdir/2.fq | samtools view -Sb -F 4 | samtools sort -o $tmpdir/1.bam
featureCounts -T $USE_CPU -t exon -g gene -a $GFF_PATH -o $OUTPUT_TXT $tmpdir/1.bam

sed -i '1d' $OUTPUT_TXT
sed -i -E 's/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)$/\1\t\6\t\7/g' $OUTPUT_TXT
sed -i '1c Geneid\tLength\tCount' $OUTPUT_TXT


#!/bin/bash

DB_PATH=~/ref/mirna.db
USE_CPU=20

INPUT_FQ=$1
OUTPUT_TXT=$2


if [[ "$INPUT_FQ" = "" || "$OUTPUT_TXT" = "" ]] ; then
    echo "USAGE: ./mirna_pipeline-count.sh input.fq output.txt"
    echo "  input.fq   : target input fastq file (gz)"
    echo "  output.txt : result miRNA count data (tsv)"
    exit 1
fi

ezcount -t $USE_CPU -d $DB_PATH -f $INPUT_FQ -c $OUTPUT_TXT --count-hide-ambiguous
if [ ! -e $OUTPUT_TXT ] ; then
    echo "trim adapter mode failed, and retry by no trim adapter mode"
    ezcount -t $USE_CPU -d $DB_PATH -f $INPUT_FQ -c $OUTPUT_TXT --count-hide-ambiguous --no-trim-adapter
fi


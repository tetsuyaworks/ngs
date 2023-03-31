#!/bin/bash

DB_PATH=~/ref/mirna.db
USE_CPU=20

INPUT_DIR=$1
shift
OUTPUT_DIR=$1
shift
SELECT_SWITCH=$1
shift
SAMPLE_LIST=($@)

if [[ ( "$INPUT_DIR" = "" || "$OUTPUT_DIR" = "" ) || ( ${#SAMPLE_LIST[@]} -gt 0 && ! ( "$SELECT_SWITCH" = "-E" || "$SELECT_SWITCH" = "-I" ) ) ]] ; then
    echo "USAGE: ./mirna_pipeline-counts.sh input_dir output_dir"
    echo "  input_dir   : target directory contain with input fastq file (gz)"
    echo "  output_dir  : output result directory of miRNA count data (tsv)"
    echo ""
    echo "USAGE: ./mirna_pipeline-counts.sh input_dir output_dir -E A00001 A00002"
    echo "  input_dir   : target directory contain with input fastq file (gz)"
    echo "  output_dir  : output result directory of miRNA count data (tsv)"
    echo "  -E A00001 A00002 ... : sample name A00001 and A00002 are not analysing (not file name)"
    echo ""
    echo "USAGE: ./mirna_pipeline-counts.sh input_dir output_dir -I A00001 A00002"
    echo "  input_dir   : target directory contain with input fastq file (gz)"
    echo "  output_dir  : output result directory of miRNA count data (tsv)"
    echo "  -I A00001 A00002 ... : analyse only sample name A00001 and A00002 (not file name)"
    exit 1
fi

SAMPLEFILE_EXP="^(.+)_S[0-9]+_R([1,2])_001\.fastq\.gz$"
declare -a samplename_list
declare -A samplefile_dict
function get_sample_name_list(){
    local samplename_list_tmp
    local samplename_tmp

    if [ ! -d $1 ] ; then
        echo "get_sample_name_list: input dir is invalid"
        return
    fi

    while read -r f; do
        if [[ ! `basename $f` =~ $SAMPLEFILE_EXP ]] ; then
            continue
        fi
        samplename_tmp=${BASH_REMATCH[1]}
        if [ "$samplename_tmp" = "Undetermined" ] ; then
            continue
        fi

        if printf '%s\n' "${SAMPLE_LIST[@]}" | grep -qx "$samplename_tmp" ; then
            if [ "$SELECT_SWITCH" = "-E" ] ; then
                continue
            fi
        else
            if [ "$SELECT_SWITCH" = "-I" ] ; then
                continue
            fi
        fi

        samplename_list_tmp+=(${BASH_REMATCH[1]})
        samplefile_dict[${BASH_REMATCH[1]},R${BASH_REMATCH[2]}]=$f
    done < <(find $1 -mindepth 1 -maxdepth 1)
    samplename_list=$( printf "%s\n" "${samplename_list_tmp[@]}" | sort -u )
}

get_sample_name_list $INPUT_DIR
echo sample name list: ${samplename_list[@]}
# echo sample dict key list: ${!samplefile_dict[@]}

for sample_name in $samplename_list; do
    echo sample name: $sample_name
    echo " R1 file name: ${samplefile_dict[$sample_name,R1]}"
    #echo " R2 file name: ${samplefile_dict[$sample_name,R2]}"
    ezcount -t $USE_CPU -d $DB_PATH -f ${samplefile_dict[$sample_name,R1]} -c $OUTPUT_DIR/$sample_name.txt --count-hide-ambiguous
    if [ ! -e $OUTPUT_TXT ] ; then
        echo "trim adapter mode failed, and retry by no trim adapter mode"
        ezcount -t $USE_CPU -d $DB_PATH -f ${samplefile_dict[$sample_name,R1]} -c $OUTPUT_DIR/$sample_name.txt --count-hide-ambiguous --no-trim-adapter
    fi
done


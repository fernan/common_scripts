#!/bin/bash
dir=$1
cd ${dir}
a=$(basename $(dirname $(grep "data ref" input.xml |cut -f 2 -d "\"")))
b=$(basename $(grep "data ref" input.xml |cut -f 2 -d "\""))
all=$(grep -i "<tr><td>Polymerase Read" results/filter_reports_filter_stats.html |cut -f 5,7 -d ">" | sed 's/<\/td>/\n/' |cut -f 1 -d "<")
read -r -a stat <<< "$all"
echo -e "tar_file\tdir\tsmrtcell\tpre-bases\tpre-reads\tpre-n50\tpre-mean_len\tpre-mean_reads\t-post-bases\post-treads\tpost-n50\tpost-mean_len\tpost-mean_reads"
echo -e "unk\t$a\t$b\t${stat[0]}\t${stat[2]}\t${stat[4]}\t${stat[6]}\t${stat[8]}\t${stat[1]}\t${stat[3]}\t${stat[5]}\t${stat[7]}\t${stat[9]}"

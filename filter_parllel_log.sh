#!/bin/bash
if [ $# -lt 1 ] ; then
	echo "usage: filter_parallel_log.sh <parallel_log_file> <parallel_CMD_file>"
	echo ""
	echo "To extract the commands that failed when running through parallel"
	echo ""
exit 0
fi

LOG="$1"
CMDS="$2"

if [ -f $LOG ];
then
   awk '$7==0' ${LOG} | cut -f 9 > .done_cmds
else
   echo "$LOG not found";
   exit
fi

grep -F -x -v -f .done_cmds ${CMDS} > ${CMDS%.*}_unfinished.txt

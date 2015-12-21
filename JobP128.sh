#!/bin/bash
# Script to generate PBS sub files reading a command file
# 01/26/2015
# Andrew Severin <severin@iastate.edu>

function printUsage () {
    cat <<EOF

Synopsis

    $scriptName [-h | --help] <Number of commands per file> <commands_file>

Description

    This is a bash script that will create a sub file to subdivide a single file and parallize a bash script 
	across 128 cpus to run on the subdivisions of the file.
    	The submission file is formatted to run on the Condo with 1 hours walltime on default queue.
	The output will be named with the bash SCRIPT and the jobID.

        -h, --help
        Brings up this help page

    
	<SCRIPT file>
	This is a bash script that you wish to run on a large file.

Author

    Andrew Severin, Genome Informatics Facilty, Iowa State University
    severin@iastate.edu
    11 June, 2015


EOF
}
if [ $# -lt 2 ] ; then
        printUsage
        exit 0
fi


SCRIPT="$2"
INFILE="$1"


function filesizefun () 
{
a=`ls -AlL $INFILE | awk '{print int($5/128/1000000)+1}'`"M"
echo $a
}
filesize="$(filesizefun)"

function readlines () {
    local N="$1"
    local line
    local rc="1"
    for i in $(seq 1 $N); do
        read line
        if [ $? -eq 0 ]; then
            echo "$line\n"
            rc="0"
        else
            break
        fi
    done
    return $rc
}
#> ${INFILE%%.*}_${num}.sub
cat <<-JOBHEAD > ${INFILE}_$SCRIPT.sub 
#!/bin/bash
#PBS -l nodes=8:ppn=16
#PBS -l walltime=1:00:00
#PBS -N ${INFILE%%.*}_${num}
#PBS -o \${PBS_JOBNAME}.o\${PBS_JOBID} -e \${PBS_JOBNAME}.e\${PBS_JOBID}
#PBS -m ae -M severin@iastate.edu
cd \$PBS_O_WORKDIR
ulimit -s unlimited
chmod g+rw \${PBS_JOBNAME}.[eo]\${PBS_JOBID}
module load parallel
parallel --env _ --jobs 16 --tmpdir /dev/shm | parallel --tmpdir /dev/shm --pipepart --block $filesize --jobs 16 --sshloginfile \$PBS_NODEFILE --joblog progress.log.\${PBS_JOBID} --workdir $PWD  -a  $INFILE -k ./$SCRIPT > ${INFILE}.\${PBS_JOBID}.out 
JOBHEAD

echo -e "\nqstat -f \"\$PBS_JOBID\" | head" >> ${INFILE}_$SCRIPT.sub

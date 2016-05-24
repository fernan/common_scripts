#!/bin/bash
#script to create a submission script that then can easily be appended to.
# 05/23/2016
#Andrew severin

function printUsage () {
    cat <<EOF

Synopsis

    $scriptName [-h | --help] BATCH_NAME NUMBERofHOURS 

Description

    This is a bash script that generates the sub file quickly.

        -h, --help
        Brings up this help page

Author

    Andrew Severin, Genome Informatics Facilty, Iowa State University
    severin@iastate.edu
    23 May, 2016


EOF
}
if [ $# -lt 2 ] ; then
        printUsage
        exit 0
fi




cat <<JOBHEAD > $1.sub
#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=$2:00:00
#PBS -N $1
#PBS -o \${PBS_JOBNAME}.o\${PBS_JOBID} -e \${PBS_JOBNAME}.e\${PBS_JOBID}
#PBS -m ae -M $netid@iastate.edu
cd \$PBS_O_WORKDIR
ulimit -s unlimited
chmod g+rw \${PBS_JOBNAME}.[eo]\${PBS_JOBID}
module use /shared/modulefiles 
module load LAS/parallel/20150922 

JOBHEAD

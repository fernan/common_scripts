#!/bin/bash
# Script to generate PBS sub files reading a command file
# 01/26/2015
# Arun Seetharam <arnstrm@iastate.edu>
 
LINES="$1"
INFILE="$2"
function readlines () {
local N="$1"
local line
local rc="1"
for i in $(seq 1 $N); do
read line
if [ $? -eq 0 ]; then
echo $line
rc="0"
else
break
fi
done
return $rc
}
num=1
while chunk=$(readlines ${LINES}); do
cat <<JOBHEAD > ${INFILE%%.*}_${num}.sub
#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=96:00:00
#PBS -N ${INFILE%%.*}_${num}
#PBS -o \${PBS_JOBNAME}.o\${PBS_JOBID} -e \${PBS_JOBNAME}.e\${PBS_JOBID}
#PBS -m ae -M arnstrm@gmail.com
cd \$PBS_O_WORKDIR
ulimit -s unlimited
chmod g+rw \${PBS_JOBNAME}.[eo]\${PBS_JOBID}
module use /shared/software/GIF/modules/
module load parallel
module load gatk
parallel --jobs 8 --sshloginfile \$PBS_NODEFILE --joblog gatk_progress_${num}.log --workdir \$PWD << EOL
JOBHEAD
echo ${chunk} >> ${INFILE%%.*}_${num}.sub
echo -e "EOL\nqstat -f \"\$PBS_JOBID\" | head" >> ${INFILE%%.*}_${num}.sub
((num++))
done<"${INFILE}"

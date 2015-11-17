#!/bin/bash

#ma is short for module add variable
#I am basing it off of github commands git add but only using the first letter of each word
#add a help message here

scriptName="ma"
function printUsage () {
    cat <<EOF

Synopsis

    $scriptName [-h | --help] <modulename> <VariableNAME> <Path2File>

Description:
	modulename: 	is the current module but does not include the version
	VariableNAME:	is the variable you want to add to the module file
	Path2File:	is the full path that you want the variable set to.

Author

    Andrew Severin, Genome Informatics Facilty, Iowa State University
    severin@iastate.edu
    26 January, 2015


EOF
}
if [ $# -lt 3 ] ; then
        printUsage
        exit 0
fi
numparamsM2=$(expr $# - 2)
MODULE=$1
VAR=$2
DIR=$3
#my attempt to combine adding of directories and preexisting variables
#DIR=$(echo "${BASH_ARGV[*]}" | cut -d " " -f -$numparamsM2)
echo $DIR
unset modulefile
module load $MODULE
echo "" | awk 'BEGIN{OFS="\t"} {print "setenv","'$MODULE'""_""'$VAR'", "'$DIR'"}' >> $modulefile
module load $MODULE

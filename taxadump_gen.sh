#!/bin/bash

# Download NCBI's taxonomic data and GenBank ID taxonomic
# assignments.

## Download taxdump (clean first)
TAXDUMP="taxdump.tar.gz"
rm --force *.dmp gc.prt readme.txt ${TAXDUMP}
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/${TAXDUMP} && \
tar -zxvf ${TAXDUMP} && \
rm --force ${TAXDUMP} {citations,division,gencode,merged,delnodes}.dmp gc.prt readme.txt

# limit search space to scientific names
NAMES="names.dmp"
grep "scientific name" ${NAMES} > ${NAMES/.dmp/_reduced.dmp}
mv ${NAMES/.dmp/_reduced.dmp} ${NAMES}

## Download taxid
# select one of the below 2 tables
# for nt database, uncheck this
#TAXID="gi_taxid_nucl.dmp.gz"
# for nr database, uncheck this
TAXID="gi_taxid_prot.dmp.gz"
rm --force ${TAXID/.gz/}*
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/${TAXID} && \
gunzip ${TAXID}

exit 0

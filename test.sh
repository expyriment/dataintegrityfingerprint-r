#!/bin/bash

ABSPATH=$(realpath ${1})
time Rscript -e "source('dif.R');  master_hash(DIF('${ABSPATH}'))"
#Rscript -e "source('dif.R');  write_checksums(DIF('${1}'), filename='checksums.R')"
#Rscript -e "source('dif.R');  master_hash(load_checksums('checksums.bash'))"

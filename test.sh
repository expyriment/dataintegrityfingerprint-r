#!/bin/bash

ABSPATH=$(realpath ${1})
time Rscript -e "library('dataintegrityfingerprint');  master_hash(DIF('${ABSPATH}'))"
#Rscript -e "library('dataintegrityfingerprint'); write_checksums(DIF('${1}'), filename='checksums.R')"
#Rscript -e "library('dataintegrityfingerprint'); master_hash(load_checksums('checksums.bash'))"

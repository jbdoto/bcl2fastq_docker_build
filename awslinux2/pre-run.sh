#!/bin/bash -e

prepare_workspace(){
  
  set -o noglob

  echo "copying files into processing directory"
  cp -R /scratch/results/samples/${OBJECT_NAME} /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/

}

# Download inputs
# Skipping this since we're using Lustre.
#prepare_workspace

#!/bin/bash -e

prepare_workspace(){

  set -o noglob

  echo "Preloading files from S3..."
  cd "/scratch/results/samples/${OBJECT_NAME}"
  find "$(pwd -P)" -type f -exec lfs hsm_restore {} \;

  # wait for restoration...
  while :; do
    # https://docs.aws.amazon.com/fsx/latest/LustreGuide/preload-file-contents-hsm.html
    REMAINING_FILES=$(find "$(pwd -P)" -type f -print0 | xargs -0 -n 1 -P 8 lfs hsm_action | grep "RESTORE" | wc -l)
    echo "Files remaining: $REMAINING_FILES"
    [[ $REMAINING_FILES -gt 0 ]] || break
    echo "$REMAINING_FILES remaining...waiting..."
    sleep 10
  done

echo "Preloading filesystem complete."
  #cp -R /scratch/results/samples/${OBJECT_NAME} /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/

}

# Download inputs
# Skipping this since we're using Lustre.
prepare_workspace

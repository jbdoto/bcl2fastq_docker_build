#!/bin/bash -e

archive_files() {

  set -o noglob

  # https://docs.aws.amazon.com/fsx/latest/LustreGuide/release-files.html
  # release files from lustre to save space:
  # Archive all files back to bucket.
  echo "Archiving files back to S3..."
  echo "Current directory: $(pwd)"
  # currently in:  /scratch/results/samples/${OBJECT_NAME}:
  find "$(pwd -P)" -type f -exec lfs hsm_archive {} \;
  while :; do
    # https://docs.aws.amazon.com/fsx/latest/LustreGuide/exporting-files-hsm.html
    REMAINING_FILES=$(find "$(pwd -P)" -type f -print0 | xargs -0 -n 1 -P 8 lfs hsm_action | grep "ARCHIVE" | wc -l)
    echo "Files remaining: $REMAINING_FILES"
    [[ $REMAINING_FILES -gt 0 ]] || break
    echo "$REMAINING_FILES remaining...waiting..."
    sleep 10
  done

  echo "Archive complete."

  # This step frees up space on the Lustre filesytem
  echo "Releasing files on Lustre filesystem..."
  find "$(pwd -P)" -type f -exec lfs hsm_release {} \;
  echo "File release complete."

}

archive_files

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --region ${AWS_REGION}
fi

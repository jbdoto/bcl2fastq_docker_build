#!/bin/bash -e

upload(){
  
  set -o noglob

  local to=$1

  echo "Uploading files post-run..."
  echo "cd /scratch/results/samples/${OBJECT_NAME}  && aws s3 cp . ${to} --recursive --exclude \"*\" --include \"*.fastq.gz\" --include\"*/Stats/*\" --include \"*IndexMetricsOut.bin\""
  cd /scratch/results/samples/${OBJECT_NAME} && aws s3 cp . ${to} --recursive --exclude "*" --include "*.fastq.gz"
  aws s3 cp ./Data/Intensities/BaseCalls/Stats ${to}/Data/Intensities/BaseCalls/Stats --recursive
  aws s3 cp ./InterOp/IndexMetricsOut.bin ${to}/InterOp/IndexMetricsOut.bin

  # https://docs.aws.amazon.com/fsx/latest/LustreGuide/release-files.html
  # release files from lustre to save space:
  echo "Releasing files from lustre..."
  # emit full path of file for hsm_release
  # can only hsm_release files that were cached from S3...so data produced during the run will cause an error.
  # we therefore filter out fastq, summary, and IndexMetricsOut.bin files.
  find "$(pwd -P)" -type f ! -name "*.fastq.gz" ! -wholename "*/Stats/*" ! -name "*IndexMetricsOut.bin" -exec lfs hsm_release {} \;
  echo "Release complete."

  # clean up generated files:
  echo "cleaning up generated files..."
  find "$(pwd -P)" -type f -name "*.fastq.gz"  -exec rm -v {} \;
  find "$(pwd -P)" -type f -wholename "*/Data/Intensities/BaseCalls/Stats/*" -exec rm -v {} \;
  find "$(pwd -P)" -type f -name "./InterOp/IndexMetricsOut.bin" -exec rm -v {} \;
  echo "cleanup done."

}

# Upload outputs post-parent job
upload "s3://${JOBRESULTS_BUCKET}/${OBJECT_NAME}/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/"

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --region ${AWS_REGION}
fi

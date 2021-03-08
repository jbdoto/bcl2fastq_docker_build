#!/bin/bash -e

upload(){
  
  set -o noglob

  local to=$1

  echo "cd /scratch/results/samples/${OBJECT_NAME}  && aws s3 cp . ${to} --recursive --exclude \"*\" --include \"*.fastq.gz\""
  cd /scratch/results/samples/${OBJECT_NAME} && aws s3 cp . ${to} --recursive --exclude "*" --include "*.fastq.gz"

  # https://docs.aws.amazon.com/fsx/latest/LustreGuide/release-files.html
  # release files from lustre to save space:
  echo "Releasing files from lustre..."
  # TODO: Not sure what's up with this currently:
  # Cannot send HSM request (use of ./Data/Intensities/BaseCalls/14584-Zymo-IndexSet2-NSQ-AllLanes_S123_L003_R1_001.fastq.gz): Operation not permitted
  # emit full path of file for hsm_release
  #find "$(pwd -P)" -type f -exec lfs hsm_release {} \;
  echo "Release complete."

}

# Upload outputs post-parent job
upload "s3://${JOBRESULTS_BUCKET}/${OBJECT_NAME}/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/"

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --region ${AWS_REGION}
fi

#!/bin/bash -e

upload(){
  
  set -o noglob

  local to=$1
  local files=$2

  for file in ${files}
  do

    echo "aws s3 cp . ${to} --recursive --exclude \"*\" --include \"${file}\""
    aws s3 cp . ${to} --recursive --exclude "*" --include "${file}"

    # TODO: sync back new zip file to S3 via HSM?
    #sudo lfs hsm_archive path/to/export/file

  done
}

# Job results path in job results bucket
if [[ $STATE_MACHINE_NAME ]]; then
  jobresults=${JOBRESULTS_BUCKET}/${SAMPLE_ID}/${STATE_MACHINE_NAME}/${EXECUTION_NAME}
else
  jobresults=${JOBRESULTS_BUCKET}/${1}
fi

# Upload outputs post-parent job
# TODO: figure this part out.
#upload "s3://${jobresults}/" "${SAMPLE_ID}_results.tar.gz" "/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}"

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace bcl2fastq --unit Count --value 1 --region ${AWS_REGION}
fi

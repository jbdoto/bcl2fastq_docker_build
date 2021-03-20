#!/bin/bash -e

put_metric_data() {

  # compute time elapsed
  end_time=$(date +%s%3N)
  time_delta=$(($end_time - ${1}))

  echo "Job took ${time_delta} ms"
  aws cloudwatch put-metric-data --metric-name JobDuration --namespace bcl2fastq --unit Milliseconds --value ${time_delta} --dimensions JobName=bcl2fastq --region ${AWS_REGION}
}

start_time=$(date +%s%3N)

pre-run.sh ""

run.sh $@

post-run.sh ""

trap 'put_metric_data ${start_time}' exit

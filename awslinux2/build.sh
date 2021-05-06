#!/bin/bash

ACCOUNT_ID=<enter_id>
REGION=us-west-2

docker build . -t bcl2fastq
docker build -f entrypoint.dockerfile . --build-arg BASE_IMAGE=bcl2fastq -t bcl2fastq
docker tag bcl2fastq ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/bcl2fastq:1.0.0
aws ecr get-login-password --region ${REGION} --profile=ryan-gsat | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/bcl2fastq:1.0.0

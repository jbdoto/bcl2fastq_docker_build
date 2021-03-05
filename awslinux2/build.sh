#!/bin/bash


docker build . -t bcl2fastq
docker build -f entrypoint.dockerfile . --build-arg BASE_IMAGE=bcl2fastq -t bcl2fastq
docker tag bcl2fastq 353276416433.dkr.ecr.us-east-1.amazonaws.com/bcl2fastq:1.0.0
aws ecr get-login-password --region us-east-1 --profile=gsat | docker login --username AWS --password-stdin 353276416433.dkr.ecr.us-east-1.amazonaws.com
docker push 353276416433.dkr.ecr.us-east-1.amazonaws.com/bcl2fastq:1.0.0

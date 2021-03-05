#!/bin/bash -e

echo "Starting bcl2fastq job..."
echo "cd /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID} && bcl2fastq"
cd "/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}" && bcl2fastq
echo "bcl2fast run complete...proceeding with post-run actions."

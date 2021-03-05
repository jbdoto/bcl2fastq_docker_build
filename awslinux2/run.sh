#!/bin/bash -e

echo "Starting bcl2fastq job..."
echo "cd /scratch/results/samples/${OBJECT_NAME} && bcl2fastq"
cd "/scratch/results/samples/${OBJECT_NAME}" && bcl2fastq
echo "bcl2fast run complete...proceeding with post-run actions."

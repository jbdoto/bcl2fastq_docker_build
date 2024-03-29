ARG SOURCE=/bcl2fastq
ARG BUILD=${SOURCE}/bcl2fastq-build
ARG INSTALL_DIR=/usr/local/bin

FROM public.ecr.aws/ubuntu/ubuntu:18.04 AS build
#  Note, this build requires the presence of the bcl2fastq2-v2-20-0-tar.zip file, available from
# https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html

# Summary of compute requirements (32GB ram required.)
# https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software/computing-requirements.html

# Metadata
LABEL container.base.image="public.ecr.aws/ubuntu/ubuntu:18.04"
LABEL software.name="bcl2fastq2"
LABEL software.version=${VERSION}
LABEL software.description="Illumina bcl2fastq2: demultiplexes sequencing data and converts BCL files."
LABEL software.website="https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software/downloads.html"
LABEL software.documentation="https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software/documentation.html"
LABEL software.license="Proprietary"
LABEL tags="Genomics"

# System and library dependencies
# See INSTALL of src folder for more info.
# Building this on Ubuntu tips:
# https://sarahpenir.github.io/linux/Installing-bcl2fastq/
# https://www.biostars.org/p/387127/
RUN apt-get -y update && \
    apt-get -y install zlib1g zlib1g-dev zlibc libc6  gcc g++ unzip make libbz2-dev && \
    apt-get clean

ARG SOURCE
ARG BUILD
ARG INSTALL_DIR

# fix missing sys/stat.h header issues
ENV C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu

ARG ZIP_NAME=bcl2fastq2-v2-20-0-tar.zip
ARG TAR_NAME=bcl2fastq2-v2.20.0.422-Source.tar.gz
COPY ./${ZIP_NAME} ${SOURCE}/${ZIP_NAME}
WORKDIR ${SOURCE}
RUN unzip ${ZIP_NAME} && \
  tar -xzvf ${TAR_NAME} && \
  rm ${ZIP_NAME} ${TAR_NAME}

WORKDIR ${BUILD}
RUN ${SOURCE}/bcl2fastq/src/configure && make

FROM public.ecr.aws/ubuntu/ubuntu:18.04 AS final

ARG BUILD
ARG INSTALL_DIR

COPY --from=build ${BUILD}/cxx/bin/bcl2fastq ${INSTALL_DIR}/bcl2fastq

WORKDIR /scratch

ENTRYPOINT ["bcl2fastq"]
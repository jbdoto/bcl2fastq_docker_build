ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN yum -y update
RUN yum -y install gettext \
                       awscli
RUN yum -y clean all

COPY ./pre-run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/pre-run.sh

COPY ./post-run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/post-run.sh

COPY ./entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh

WORKDIR /scratch

ENTRYPOINT [ "entrypoint.sh" ]

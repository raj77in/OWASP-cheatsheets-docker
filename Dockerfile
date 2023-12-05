# syntax = docker/dockerfile:experimental
# Safer with 1.0:  syntax = docker/dockerfile:1.0-experimental
# Syntax directive must be first line
# See: https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md


FROM fedora
# OCI Annotations from https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.maintainer="Amit Agarwal"     \
  org.opencontainers.image.authors="" \
  org.opencontainers.image.title="OWASP-CheatSheets" \
  org.opencontainers.image.vendor="Individual"              \
  org.opencontainers.image.url="https://blog.amit-agarwal.co.in"              \
  org.opencontainers.image.documentation="https://blog.amit-agarwal.co.in" \
  org.opencontainers.image.description="Serve OWASP CheatSheets" \
  # SPDX License Expression format; \
  # UNLICENSED is used for private licenses \
  org.opencontainers.image.licenses="UNLICENSED"                    \
  org.opencontainers.image.version="${ELKMAN_VERSION}" \
  org.opencontainers.image.version="RELEASE"

#      org.opencontainers.image.revision="" FROM git
#      org.opencontainers.image.created="2020-05-01T01:01:01.01Z"

WORKDIR /app
RUN dnf update -y; dnf install -y make unzip python3-pip ; dnf clean all -y
ADD https://github.com/OWASP/CheatSheetSeries/archive/refs/heads/master.zip /app
RUN chown -R 1001 /app
RUN alternatives --install /usr/bin/python python /usr/bin/python3
RUN unzip master.zip
ENV PATH=/root/.local/bin:$PATH
WORKDIR /app/CheatSheetSeries-master/
RUN echo install python pre-req ; make install-python-requirements
RUN echo make site; make generate-site
EXPOSE 8000
ENTRYPOINT [ "python", "-m", "http.server", "-d", "generated/site" ]

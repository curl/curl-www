FROM debian:bullseye-slim
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      gcc \
      git \
      make

RUN git clone --depth 1 https://github.com/bagder/fcpp \
    && cd fcpp  \
    && make

FROM debian:bullseye-slim
COPY --from=0 /fcpp/fcpp /usr/bin
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl  \
    libhtml-html5-entities-perl \
    libcgi-pm-perl  \
    libcurl4-gnutls-dev \
    make  \
    pandoc  \
    perl  \
    roffit  \
    zip

CMD ["/bin/bash","-l"]

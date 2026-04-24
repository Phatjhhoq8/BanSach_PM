FROM mono:6.12

RUN printf 'deb http://archive.debian.org/debian buster main\ndeb http://archive.debian.org/debian-security buster/updates main\ndeb http://archive.debian.org/debian buster-updates main\n' > /etc/apt/sources.list \
    && printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99archive \
    && apt-get update \
    && apt-get install -y --no-install-recommends mono-xsp4 curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN sed -i 's/\r$//' /app/docker/entrypoint.sh \
    && chmod +x /app/docker/entrypoint.sh \
    && mkdir -p /app/Source/img/books \
    && chmod -R 775 /app/Source/img/books

EXPOSE 8080
ENTRYPOINT ["/app/docker/entrypoint.sh"]

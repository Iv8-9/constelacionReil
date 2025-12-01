FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl unzip xz-utils git

# Instalar Flutter
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz | tar -C /opt -xJ

# Configurar Git
RUN git config --global --add safe.directory /opt/flutter

ENV PATH="$PATH:/opt/flutter/bin"

COPY . /app
WORKDIR /app

# Solo verificar, sin build
RUN flutter config --enable-web && \
    flutter pub get && \
    flutter analyze

# Exponer puerto
EXPOSE 8080

# Comando simple
CMD ["echo", "App configurada correctamente"]
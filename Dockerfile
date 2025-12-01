FROM ubuntu:22.04

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    xz-utils \
    git \
    bash \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz | tar -C /opt -xJ

# Configurar Git safe directory y Flutter
RUN git config --global --add safe.directory /opt/flutter && \
    /opt/flutter/bin/flutter config --enable-web && \
    /opt/flutter/bin/flutter --version

# Configurar environment PATH
ENV PATH="$PATH:/opt/flutter/bin"

# Crear usuario no-root para Flutter
RUN useradd -m -u 1000 flutteruser && \
    chown -R flutteruser:flutteruser /opt/flutter

# Crear directorio de la app y cambiar propietario
RUN mkdir /app && chown flutteruser:flutteruser /app

# Cambiar a usuario no-root
USER flutteruser

# Copiar código de la aplicación
COPY --chown=flutteruser:flutteruser . /app
WORKDIR /app

# Obtener dependencias
RUN flutter pub get

# Build para web
RUN flutter build web --release --web-renderer canvaskit

EXPOSE 8080

CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
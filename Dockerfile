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

# Configurar environment PATH
ENV PATH="$PATH:/opt/flutter/bin"

# Configurar Flutter para web
RUN flutter config --enable-web
RUN flutter doctor

# Copiar código de la aplicación
COPY . /app
WORKDIR /app

# Obtener dependencias USANDO FLUTTER, no dart
RUN flutter pub get

# Build para web
RUN flutter build web --release --web-renderer canvaskit

EXPOSE 8080

CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
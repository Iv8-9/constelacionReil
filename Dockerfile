# Etapa de build
FROM ghcr.io/cirruslabs/flutter:stable as build

WORKDIR /app

# Copiar solo pubspec primero para cache
COPY pubspec.* ./

# Obtener dependencias
RUN flutter pub get

# Copiar el resto del proyecto
COPY . .

# Habilitar Web y construir
RUN flutter config --enable-web
RUN flutter build web --release --no-tree-shake-icons

# Etapa final
FROM nginx:alpine

# Copiar build de Flutter Web
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

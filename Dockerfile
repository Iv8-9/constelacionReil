# Etapa de build
FROM ghcr.io/cirruslabs/flutter:stable as build

WORKDIR /app
COPY . .

# Construir Flutter Web
RUN flutter config --enable-web
RUN flutter build web --release

# Etapa final: servidor web para archivos estáticos
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

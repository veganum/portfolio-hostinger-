# Etapa de build
FROM node:22.13-alpine AS build
WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm ci

# Copiar el resto del código y compilar Angular
COPY . .
RUN npm run build -- --configuration=production

# Etapa de runtime
FROM node:22.13-alpine AS runtime
WORKDIR /app

# Servidor estático
RUN npm install -g serve

# Copiamos solo los archivos estáticos del build
# OJO: este path debe coincidir con angular.json -> outputPath
COPY --from=build /app/dist/portfolio-hostinger/browser ./dist

EXPOSE 4173
CMD ["serve", "-s", "dist", "-l", "4173"]

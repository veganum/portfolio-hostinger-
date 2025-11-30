# Etapa de build
FROM node:22.12-alpine AS build

WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el resto del código
COPY . .

# Build Angular en modo producción
RUN npm run build -- --configuration=production

# Etapa de runtime
FROM node:22.12-alpine AS runtime

WORKDIR /app

# Servidor estático
RUN npm install -g serve

# Copiamos el build generado
COPY --from=build /app/dist/portfolio-hostinger/browser ./dist

EXPOSE 4173

CMD ["serve", "-s", "dist", "-l", "4173"]

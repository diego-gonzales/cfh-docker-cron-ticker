# Stage 1: Dependencies
FROM node:19.2-alpine3.16 AS dependencies

WORKDIR /app

COPY package.json ./

RUN npm install

# Stage 2: Tester and Builder
FROM node:19.2-alpine3.16 AS builder

WORKDIR /app

COPY --from=dependencies /app/node_modules ./node_modules

COPY . .

RUN npm run test

# En caso de estar en un app de React, Angular, etc. se debe ejecutar el comando de build: npm run build, en nuestro no es necesario
# RUN npm run build


# Optional Stage: Production Dependencies
FROM node:19.2-alpine3.16 AS production-dependencies

WORKDIR /app

COPY package.json ./

RUN npm install --prod

# Stage 3: Release
FROM node:19.2-alpine3.16 AS release

WORKDIR /app

COPY --from=production-dependencies /app/node_modules ./node_modules

COPY app.js ./

COPY tasks/ ./tasks

# RUN npm install --prod # En caso de no usar el optional stage

CMD ["npm", "start"]
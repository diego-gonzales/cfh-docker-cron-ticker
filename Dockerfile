# This image contains: alpine, a lightweight linux distro, with node installed. This linux version contains by default an '/app' folder (usually our app is going to be here), so we don't need to create it. Also we can find folders as '/usr', '/lib', etc.
# --platform flag is used to specify the architecture of the image.By default, docker will use the architecture of our machine, but if we want to use another architecture like linux/arm64, we need to specify it.
# Instead of specifiying the architecture, we can use the 'buildx' command, which is a CLI plugin for docker, that allows us to build images for multiple architectures at the same time. To use it, we need to install it first: docker buildx install, then we need to create a builder: docker buildx create --name mybuilder, and finally we need to use it: docker buildx use mybuilder. Now we can build images for multiple architectures at the same time: docker buildx build --platform linux/amd64,linux/arm64 -t myimage:latest --push .
# $BUILDPLATFORM is a variable that contains the architecture of the image that we are building.
FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16

# We set the working directory to '/app' folder (it is as we said 'cd /app')
WORKDIR /app

# We copy the package.json file to the '/app' folder
# COPY <source> (relative to the actual directory) <destination> (relative to the WORKDIR)
COPY package.json ./

# We install the dependencies
# RUN se utiliza para ejecutar comandos durante la construcción de la imagen
RUN npm install

# We copy all the files from the actual directory to the '/app' folder (you can use COPY . ./)
# Doing it this way, the next time we build the image, docker will use the cache of the previous steps, so it will be faster, because package.json doesn't change, then the dependencies doesn't need to install again, instead of doing it this way: COPY . ./ (it will copy all the files and then it will install the dependencies)
# When we copy all the files, we need to create a .dockerignore file, to specify the files and folders that we don't want to copy to the image
COPY . .

# Do testing
RUN npm run test

# Delete files and folders unnecessary for production
RUN rm -rf tests && rm -rf node_modules

# We install the production dependencies (we don't need the dev dependencies, ex. jest)
RUN npm install --prod

# We execute the command 'npm start' when the container is running
# CMD se utiliza para especificar el comando que se ejecutará cuando se inicie un contenedor basado en la imagen.
# Solo puede haber un comando CMD por Dockerfile. Si se especifican varios comandos, solo se ejecutará el último comando.
CMD ["npm", "start"]
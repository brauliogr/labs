FROM node:10

# Cria o diretorio do app
WORKDIR /appwork

# Installando  as dependencias do app
COPY package*.json ./


RUN npm install --no-optional && npm cache clean --force

# Copia o restante dos aquivos para o app
COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]

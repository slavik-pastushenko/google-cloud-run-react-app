FROM node:14.5-alpine as react-build

ARG VERSION="production"

LABEL com.example.service="front-end"
LABEL com.example.version=$VERSION

WORKDIR /app

COPY package*.json /app/

RUN npm install --only=production

COPY src /app/src
COPY public /app/public

RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/configfile.template

ENV PORT 3000
ENV HOST 0.0.0.0

RUN sh -c "envsubst '\$PORT'  < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf"

COPY --from=react-build /app/build /usr/share/nginx/html

EXPOSE 3000 80

CMD ["nginx", "-g", "daemon off;"]

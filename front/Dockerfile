# build stage
FROM node:lts-alpine as build-stage
ENV VUE_APP_BACKEND_SERVER=/${_VUE_APP_BACKEND_SERVER}
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run gcpbuild

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
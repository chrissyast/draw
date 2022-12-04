# build stage
FROM node:14 as build-stage
WORKDIR .
# copy package.json and package-lock.json (for more details on why we copy both these files and the project files and folders check this link out.
COPY package*.json ./
# install project dependencies
RUN npm install
# copy project directory to the working directory
COPY . .
# build app
RUN npm run build
# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage dist /usr/share/nginx/html
# specify port to access webapp through
EXPOSE 80
CMD [ "http-server", "dist", "-p", "80"]
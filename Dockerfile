#--------------------------------------
# Stage: Compile Apps
#--------------------------------------
FROM node:10.16 AS builder

ENV REFRESHED_AT 2019-12-08

WORKDIR /app

# Use package.json for Docker (without package version)
COPY js-app/package.json /app/package.json
COPY js-app/ /app/

RUN npm install

COPY . /app/

# development or production
ARG NODE_ENV=development
RUN npm run build


#--------------------------------------
# Stage: Packaging Apps
#--------------------------------------
FROM nginx:1.16-alpine

COPY nginx-conf/app.conf /etc/nginx/conf.d/default.conf

VOLUME /app
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

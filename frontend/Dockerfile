FROM public.ecr.aws/docker/library/node:20.18.1-alpine3.19 as build
RUN apk add --no-cache protoc

WORKDIR /app



COPY package.json .
COPY package-lock.json .


# RUN yarn install
RUN npm install 
COPY . .
RUN npm run build





FROM nginx
EXPOSE 80
COPY --from=build /app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
# This is multi step build.
# ---- Build phase
# idea is to use base OS 1, install dependencies and then run "npm run build"
# to create production ready file folder. We do not care about dependencies and
# all the other files.

FROM node:alpine as builder
# here we tagged this phase "as builder"
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
# Because this is for production, we just COPY . . all source code. We do not
# need to setup any volumes to reflect changes in source files anymore.
RUN npm run build
# This build folder will be created in /app/build



# ---- Run phase
# Here, we use nginx as base OS and simply copy build final folder on it from
# build phase. Everything else gets dropped.
FROM nginx
# as we start writing FROM, docker understands that this is a new block
EXPOSE 80
# because when we run web app from command line, we map ports. elasticbeanstalk
# will see this and map all incoming traffic to this port.
COPY --from=builder /app/build /usr/share/nginx/html
# what we are saying here is that from builder phase /app/build folder we want
# to copy everything to nginx folder that serves user by default
# ngnx does not need RUN command because it runs automatically

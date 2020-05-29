FROM hypriot/wiringpi
MAINTAINER pdiegmann@gmail.com

RUN apt-get update
RUN apt-get install -y node npm
RUN npm install child_process --save \
	npm install async --save \
	npm install body-parser --save

COPY node_modules /data/node_modules
COPY server.js /data/server.js

EXPOSE 8672

ENTRYPOINT ["nodejs", "server"]

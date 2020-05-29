FROM hypriot/wiringpi
MAINTAINER pdiegmann@gmail.com

RUN apt-get remove -y node npm child_process async body-parser
RUN apt-get update
RUN apt-get install -y node npm
RUN npm install child_process --save \
        npm install async --save \
        npm install body-parser --save

#COPY node_modules /data/node_modules
ADD ./server.js /data/server.js

EXPOSE 8672

ENTRYPOINT ["nodejs", "server"]

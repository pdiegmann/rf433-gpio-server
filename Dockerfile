
#FROM hypriot/wiringpi
#FROM sourit/wiringpi
FROM sourit/wiringpi-c
MAINTAINER pdiegmann@gmail.com

#RUN apt-get update
#RUN pip install --upgrade pip && pip install -U wiringpi
#RUN sudo apt-get purge wiringpi
#RUN sudo apt-get install wiringpi
#RUN gpio -v
#RUN apt-get install --upgrade -y node npm git
#RUN apt-get update && apt-get upgrade -y node

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs git

RUN git clone https://github.com/xkonni/raspberry-remote.git && cd raspberry-remote && make send && sudo cp ./send /usr/local/bin/ && sudo ln -s /usr/local/bin/send /usr/bin/send
RUN npm install child_process --save \
        npm install async --save \
        npm install body-parser --save
RUN cp -r node_modules /data/

#COPY node_modules /data/node_modules
ADD ./server.js /data/server.js

EXPOSE 8672

ENTRYPOINT ["nodejs", "/data/server.js"]
#CMD ["/bin/sh"]

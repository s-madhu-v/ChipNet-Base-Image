FROM alpine:edge
LABEL maintainer="Surisetti Madhu Vamsi <xpdbymadhu@gmail.com>"

ARG PASSWORD
ARG NGROK_AUTH_KEY
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${NGROK_AUTH_KEY}" > /ngrok_auth.txt
# add openssh and clean
RUN apk add --update openssh \
&& rm  -rf /tmp/* /var/cache/apk/*
# add python3
RUN apk add python3
RUN apk add curl
# install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
RUN tar -xzvf ngrok-v3-stable-linux-amd64.tgz
RUN mv ngrok /usr/local/bin/ngrok
RUN chmod +x /usr/local/bin/ngrok
# RUN python3 -m ensurepip --upgrade
# RUN python3 -m pip install pyngrok
# Just a temporary file
COPY start-ngrok.sh .
COPY stop-ngrok.sh .
RUN ngrok config add-authtoken ${NGROK_AUTH_KEY}
# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
# enable root login of ssh
RUN echo "PermitRootLogin yes" > /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

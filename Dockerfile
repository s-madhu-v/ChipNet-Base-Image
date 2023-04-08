FROM alpine:edge
LABEL maintainer="Surisetti Madhu Vamsi <xpdbymadhu@gmail.com>"

ARG PASSWORD
echo "root:${PASSWORD}" | chpasswd
# add openssh and clean
RUN apk add --update openssh \
&& rm  -rf /tmp/* /var/cache/apk/*
# add python3
RUN apk add python3
# install ngrok
wget --output-document /usr/local/bin/ngrok https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
chmod +x /usr/local/bin/ngrok
# Just a temporary file
COPY hello.txt .
# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]

FROM ubuntu:18.04
LABEL maintainer="Jared Harrington-Gibbs"
LABEL description="A docker running a completely insecure telnet server"

ENV USERPASS **String**

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install telnetd xinetd python2.7 python-pip
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/*

RUN echo "# default: on \n \
    # description: The telnet server serves telnet sessions; it uses unencrypted username/password pairs for authentication. \n \
    service telnet \n \
    { \n \
    disable = no \n \
    flags           = REUSE \n \
    socket_type     = stream \n \
    wait            = no \n \
    user            = root \n \
    server          = /usr/sbin/in.telnetd \n \
    log_on_failure  += USERID \n \
    }" | tee -a /etc/xinetd.d/telnet && \
    rm -f /etc/securetty



COPY telnet-entrypoint.sh /
RUN ["chmod", "+x", "/telnet-entrypoint.sh"]
#ENTRYPOINT ["/telnet-entrypoint.sh"]
#ENTRYPOINT ["/telnet-entrypoint.sh", "bash"]
ENTRYPOINT ["bash"]
CMD ["-c","xinetd -dontfork -stayalive"]

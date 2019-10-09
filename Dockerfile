FROM ubuntu:18.04
LABEL maintainer="Jared Harrington-Gibbs"
LABEL description="A docker running a completely insecure telnet server"

ARG USERPASS=production
ENV USERPASS="${USERPASS}"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install telnetd xinetd python2.7 python-pip
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/*
RUN useradd -u 14 bss
RUN echo bss:$USERPASS | chpasswd && \
		echo "# default: on \n \
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

ENTRYPOINT ["bash"]
CMD ["-c","xinetd -dontfork -stayalive"]

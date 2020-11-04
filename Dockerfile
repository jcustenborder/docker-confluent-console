FROM confluentinc/cp-ksqldb-cli:6.0.0

RUN apt-get update && apt-get install -y openssh-server mysql-client
RUN mkdir -p /var/run/sshd /usr/logs/ksql-cli
RUN chmod 777 /usr/logs/ksql-cli
ADD entrypoint.sh /bin

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENTRYPOINT ["/bin/entrypoint.sh"]

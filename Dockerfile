FROM confluentinc/cp-ksqldb-cli:6.0.0

USER root

### RUN yum update -y && yum install -y openssh-server mysql-client
RUN yum install -y http://vault.centos.org/8.1.1911/BaseOS/x86_64/os/Packages/openssh-server-8.0p1-4.el8_1.x86_64.rpm http://vault.centos.org/8.1.1911/BaseOS/x86_64/os/Packages/openssh-8.0p1-4.el8_1.x86_64.rpm
RUN yum install -y http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-common-5.7.30-1.el7.x86_64.rpm
RUN yum install -y http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-libs-5.7.30-1.el7.x86_64.rpm
RUN yum install -y http://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-client-5.7.30-1.el7.x86_64.rpm
RUN mkdir -p /var/run/sshd /usr/logs/ksql-cli
RUN chmod 777 /usr/logs/ksql-cli
ADD entrypoint.sh /bin

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# generate host key
RUN cd /etc/ssh && ssh-keygen -A

ENTRYPOINT ["/bin/entrypoint.sh"]

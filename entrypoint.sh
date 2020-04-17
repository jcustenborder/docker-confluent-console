#!/usr/bin/env bash
if [[ -v SSH_USERNAME ]]; then
    echo "Adding user ${SSH_USERNAME}"
    useradd -m "${SSH_USERNAME}" --shell /bin/bash
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
fi

if [[ -v SSH_ROOT_PASSWORD ]]; then
    echo "Changing root password"
    echo "root:${SSH_ROOT_PASSWORD}" | chpasswd
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
fi

if [[ -v KSQL_URL ]]; then
    echo "alias ksql='/usr/bin/ksql ${KSQL_URL}'" >> /home/${SSH_USERNAME}/.bash_aliases
fi

if [[ -v MYSQL_USERNAME && -v MYSQL_PASSWORD ]]; then
echo "[client]
user=${MYSQL_USERNAME}
password=${MYSQL_PASSWORD}
host=${MYSQL_HOST}
" > /home/${SSH_USERNAME}/.my.cnf
fi


/usr/sbin/sshd -E /var/log/sshd -p 3000
sleep 1
tail -f /var/log/sshd
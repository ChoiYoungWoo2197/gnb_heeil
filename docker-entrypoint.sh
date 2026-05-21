#!/bin/bash
set -e

# MariaDB 초기화 (최초 1회)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    mysqld_safe --skip-networking &
    sleep 5

    mysql -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS gnb_heeil CHARACTER SET utf8 COLLATE utf8_unicode_ci;
        CREATE USER IF NOT EXISTS 'gnb_heeil'@'localhost' IDENTIFIED BY 'gnb_heeil';
        GRANT ALL PRIVILEGES ON gnb_heeil.* TO 'gnb_heeil'@'localhost';
        FLUSH PRIVILEGES;
EOSQL

    mysqladmin -u root shutdown
    sleep 2
fi

mkdir -p /var/www/html/data
chmod 707 /var/www/html/data

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

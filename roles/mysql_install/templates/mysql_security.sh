#!/bin/bash
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant all privileges on *.* to {{ mysql_database_user }}@'{{ ansible_default_ipv4.address }}' identified by '{{ mysql_passwd }}' with grant option;"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant PROCESS,REPLICATION CLIENT ON *.* TO 'zabbix'@'%' identified BY 'zabbix';"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "grant ALL PRIVILEGES ON *.* TO 'wxf'@'%' identified BY 'wxf';"

{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "drop database test;"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "update mysql.user set password=password('{{ mysql_passwd }}') where user='{{ mysql_database_user }}' and host='localhost';"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "delete from mysql.user where password='';"
{{ mysql_basedir }}/bin/mysql -h localhost -u {{ mysql_database_user }} -P {{ mysql_port }} -S {{ mysql_sock }} -e "flush privileges;"

firewall-cmd --zone=public --add-port={{ mysql_port }}/tcp --permanent
firewall-cmd --reload

iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3306 -j ACCEPT
service iptables save
service iptables restart


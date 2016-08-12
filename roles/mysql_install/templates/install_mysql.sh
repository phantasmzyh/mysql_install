#!/bin/bash
mv /tmp/my.cnf {{ mysql_datadir }}/my.cnf
chown -R {{ mysql_user }}:{{ mysql_user }} {{ mysql_datadir }} {{ mysql_basedir }}
###init mysql db###"
{{ mysql_basedir }}/scripts/mysql_install_db --defaults-file={{ mysql_datadir }}/my.cnf --basedir={{ mysql_basedir }} --datadir={{ mysql_datadir }} --user={{ mysql_user }} >> /dev/null 2>&1 

# sleep 30  
mv {{ mysql_basedir }}/my.cnf {{ mysql_basedir }}/my.cnf.`date +%Y%m%d%H%M%S`
 
/etc/init.d/mysqld start 

# sleep 10 
ln -s -f {{ mysql_basedir }}/bin/mysql /usr/bin/mysql
ln -s -f {{ mysql_sock }} /tmp/mysql.sock
chkconfig --add mysqld
check_mysql=$(ps aux|grep mysql|grep -v grep|grep -v ansible|wc -l)
rm -rf /tmp/$(basename $0)

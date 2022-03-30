# Mysql

## Mysql Client installieren

für Ubuntu

    sudo apt-get install -y mysql-client-core-5.7

für Centos

     yum install -y mysql



## Mysql Docker Image ausführen

Mysql wird Port 3306 exposen. Das Mysql Datenverzeichnis wird lokal nach **/opt/data** geschrieben. Das Mysql Password wird  über die Environment Variable **MYSQL_ROOT_PASSWORD=passwd** gesetzt.

    docker  run --name db01 -v /opt/data:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -d mysql:5.7


## Mysql testen

> **-h 10.0.2.15** ist die IP Adresse der VM und muss ggF. angepasst werden. Zum Testen eine neue Datenbank **newdb** anlegen und als Kontrolle im Verzeichniss **/opt/data** zeigen.

````
root@ubuntu-xenial:/opt/data# mysql -uroot -p -h 10.0.2.15
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.25 MySQL Community Server (GPL)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database newdb;
Query OK, 1 row affected (0.01 sec)

mysql> exit
Bye
root@ubuntu-xenial:/opt/data# ls -l
total 188480
-rw-r----- 1 vboxadd vboxsf       56 Mar 18 12:30 auto.cnf
-rw------- 1 vboxadd vboxsf     1679 Mar 18 12:30 ca-key.pem
-rw-r--r-- 1 vboxadd vboxsf     1107 Mar 18 12:30 ca.pem
-rw-r--r-- 1 vboxadd vboxsf     1107 Mar 18 12:30 client-cert.pem
-rw------- 1 vboxadd vboxsf     1679 Mar 18 12:30 client-key.pem
-rw-r----- 1 vboxadd vboxsf     1340 Mar 18 12:30 ib_buffer_pool
-rw-r----- 1 vboxadd vboxsf 79691776 Mar 18 12:30 ibdata1
-rw-r----- 1 vboxadd vboxsf 12582912 Mar 18 12:30 ibtmp1
drwxr-x--- 2 vboxadd vboxsf     4096 Mar 18 12:30 mysql
drwxr-x--- 2 vboxadd vboxsf     4096 Mar 18 12:37 newdb
drwxr-x--- 2 vboxadd vboxsf     4096 Mar 18 12:30 performance_schema
-rw------- 1 vboxadd vboxsf     1679 Mar 18 12:30 private_key.pem
-rw-r--r-- 1 vboxadd vboxsf      451 Mar 18 12:30 public_key.pem
-rw-r--r-- 1 vboxadd vboxsf     1107 Mar 18 12:30 server-cert.pem
-rw------- 1 vboxadd vboxsf     1675 Mar 18 12:30 server-key.pem
drwxr-x--- 2 vboxadd vboxsf    12288 Mar 18 12:30 sys
root@ubuntu-xenial:/opt/data#

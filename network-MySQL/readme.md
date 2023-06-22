# MySQL-Client mit MySQL-Server über Docker-Netzwerk

## Aufgabe
Ein Container Image erstellen welches nach dem Starten direkt eine Verbindung zu einer MySQL Datenbank, ebenfalls in einem Container, aufbaut. Die Kommunikation erfolgt dabei ausschliesslich über ein dedizierte Docker-Netzwerk, welches von ausserhalb nicht zugänglich ist.

### Dockerfile 

Mit dem `ENTRYPOINT mysql -uroot -p -h 172.77.1.2` wird sich der Client nach dem Starten des Container direkt mit der angegebenen Datenbank unter `172.77.1.2`vebinden

```
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y mysql-client
ENTRYPOINT mysql -uroot -p -h 172.77.1.2
```

### Image builden

MySQL-Client Image builden

    $ docker build -t mysql-client:1.0 .

### Mysql Container mit exposed Ports

Mysql Container mit Port 3306 exposed. Das Mysql Datenverzeichnis wird lokal nach **/opt/data** geschrieben. Das Mysql Password wird  über die Environment Variable **MYSQL_ROOT_PASSWORD=passwd** gesetzt.

    $ docker  run --rm --name db01 -v /opt/data:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -d mariadb:10.6.14

Mit `nc` Port `3306` testen

```
# nc -vz localhost 3306
Connection to localhost (127.0.0.1) 3306 port [tcp/mysql] succeeded!
```
MySQL-Server ist über Port 3306 vom loaklen Hostsystm erreichbar.


### Docker Netzwerk

Docker Netzwerk `mynet` mit dem Subnet `172.77.1.0/24` erstellen

    $ docker network create --subnet 172.77.1.0/24 mynet

### Mysql mit Docker-Netzwerk

MySQL Container mit Docker-Netzwerk `mynet` und statischer IP `172.77.1.2` starten.

    $ docker  run --rm --name db01 -v /opt/data:/var/lib/mysql --network mynet --ip 172.77.1.2 -e MYSQL_ROOT_PASSWORD=passwd -d mariadb:10.6.14

Der MySQL-Server ist jetzt nur noch im Docker-Netzwerk `mynet` über Port 3306 erreichbar. Vom Hostsystem ist kein Zugriff auf den Port 3306 des MySQL-Server möglich.

Mit `nc` Port `3306` testen

```
# nc -vz localhost 3306
nc: connect to localhost (127.0.0.1) port 3306 (tcp) failed: Connection refused
```

### Client Container starten

Der MySQL Client im Container verbindet sich über das Docker Netzwerk `mynet` mit der Datenbank im Container `db01`. 
Beim Starten des Container wird wie schon beim Server das Docker-Netzwerk und die IP-Adresse des angegebn.

    $ docker run --rm -it --name client --network mynet --ip 172.77.1.3 mysql-client:1.0

Da beim Image Builden der `ENTRYPOINT mysql -uroot -p -h 172.77.1.2` angegeben wurde, verbindet sich der MySQL-Client des `client` Container direkt nach dem Starten mit der angegebn IP des Servers.

```
$ docker run --rm -it --name client --network mynet --ip 172.77.1.3 mysql-client:1.0
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.37 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> 
```





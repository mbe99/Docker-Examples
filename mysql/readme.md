# Mysql

## Container Image mit Mysql Client erstellen
Ein Container Image erstellen, welches nach dem Starten eine Verbindung zu einer MySQL datenbank welche in einem anderen Container läuft aufbaut. Die Komunikation erfolgt dabei ausschliesslich in einem dedizierten 

### Dockerfile 

```
FROM debian:stretch-slim
RUN apt-get update && apt-get install -y mysql-client
ENTRYPOINT mysql -uroot -p -h 172.77.1.2
```

### Image builden

```
$ docker build -t sqlclient .
```


### Mysql Docker Image ausführen und Ports exposen

Mysql wird Port 3306 exposen. Das Mysql Datenverzeichnis wird lokal nach **/opt/data** geschrieben. Das Mysql Password wird  über die Environment Variable **MYSQL_ROOT_PASSWORD=passwd** gesetzt.

    $ docker  run --name db01 -v /opt/data:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=passwd -d mysql:5.7

Mit `telnet` Port testen

    $ telnet localhost 3306


###

Internet Netzwerk `mynet` erstellen

    $ docker network create --subnet 172.77.1.0/24 mynet




### Mysql Docker Image ausführen und interners Netzwerk `mynet` verwenden

    $ docker  run --name db01 -v /opt/data:/var/lib/mysql --network mynet -e MYSQL_ROOT_PASSWORD=passwd -d mysql:5.7


### Client Container starten

Der MySQL Client im Container verbindet sich über das Docker Netzwerk `mynet` mit der Datenbank im Container `db01`. Die Kommunikation zwischen Client uns Server ist nur innerhalb diesem Netzwerk möglich und von aussen her nicht zugänglich

Mit `telnet` Port testen

    $ telnet localhost 3306


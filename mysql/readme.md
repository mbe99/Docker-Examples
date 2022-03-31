# Mysql

## Container Image mit Mysql Client erstellen
Ein Container Image erstellen das nach dem Starten direkt eine Verbindung zu einer MySQL Datenbank, welche ebenfalls in einem Container läuft, aufbaut. Die Kommunikation erfolgt dabei ausschliesslich in einem dedizierte Docker-Netzwerk.

### Dockerfile 

Mit `ENTRYPOINT mysql -uroot -p -h 172.77.1.2` wird sich der Client direkt mit der angegebn Datenbank vebinden

```
FROM debian:stretch-slim
RUN apt-get update && apt-get install -y mysql-client
ENTRYPOINT mysql -uroot -p -h 172.77.1.2
```

Client Image builden

    $ docker build -t mysql-client:1.0 .

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

Internes Docker Netzwerk `mynet` erstellen

    $ docker network create --subnet 172.77.1.0/24 mynet

### Mysql Docker Image ausführen und interners Netzwerk `mynet` mit statischer IP `172.77.1.2` verwenden

    $ docker  run --name db01 -v /opt/data:/var/lib/mysql --network mynet --ip 172.77.1.2 -e MYSQL_ROOT_PASSWORD=passwd -d mysql:5.7

Der MySQL server ist nur über das Docker-Netzwerk `mynet` unter Port 3306 erreichbar. Vom Host System ist kein Zugriff auf den Port 3306 des MySQL Server möglich.

Mit `telnet` Port testen

    $ telnet localhost 3306

### Client Container starten

Der MySQL Client im Container verbindet sich über das Docker Netzwerk `mynet` mit der Datenbank im Container `db01`. 

    docker run --rm -it --name client --network mynet --ip 172.77.1.3 mysql-client:1.0






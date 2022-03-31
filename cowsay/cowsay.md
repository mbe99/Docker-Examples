# cowsay

## laufenden Container modifizieren

### Debian Container starten

Docker Container starten und eine **bash** aufrufen. 

```
# docker run -it --name cowsay --hostname cowsay debian:stretch-slim bash
root@cowsay:/# exit
exit
```

### im Container die Software *cowsay* und *fortune* install

```
# docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS                       PORTS     NAMES
1aa442bb70be   debian:stretch-slim   "bash"                   2 minutes ago    Exited (0) 18 seconds ago              cowsay

# docker start cowsay

# docker exec -it cowsay bash
root@cowsay:/# apt-get update
....
Fetched 7877 kB in 7s (1089 kB/s)
Reading package lists... Done

root@cowsay:/# apt-get install -y cowsay fortune

~
update-alternatives: using /usr/bin/file-rename to provide /usr/bin/rename (rename) in auto mode
Processing triggers for libc-bin (2.24-11+deb9u4) 
~

root@cowsay:/#

```

### testen im Container

``` 
root@cowsay:/# /usr/games/fortune |/usr/games/cowsay
 ________________________________________
/ I don't know half of you half as well  \
| as I should like; and I like less than |
| half of you half as well as you        |
| deserve.                               |
|                                        |
\ -- J. R. R. Tolkien                    /
 ----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
root@cowsay:/# exit
```

### Veränderungen anzeigen

Mit `docker diff` lassen sich die Veränderungen an einem laufenden Container gegenüber seinem Image anzeigen.

```
root@docker:~# docker diff cowsay
C /etc
C /etc/ld.so.cache
C /etc/alternatives
A /etc/alternatives/rename
A /etc/services
A /etc/rpc
A /etc/network
A /etc/networks
A /etc/perl
A /etc/perl/CPAN
A /etc/perl/Net
A /etc/perl/Net/libnet.cfg
A /etc/perl/sitecustomize.pl
A /etc/protocols
C /usr
C /usr/share
A /usr/share/cowsay
A /usr/share/cowsay/cows
... output truncated
```

## Docker Image vom modifizierten Container erstellen

### docker commit

```
$ docker commit cowsay cowsay:1-0
sha256:3394945165c33c08027a694632a9fad04b358764f33a83c8aa9015b25111d90b
```

Nun steht das neu erstellte Image `cowsay:1-0` lokal zur Verfügung.

```
$ docker images
REPOSITORY   TAG            IMAGE ID       CREATED          SIZE
cowsay       1-0            84321b24ac87   28 minutes ago   114MB
debian       stretch-slim   ab15bb5b14e4   10 days ago      55.4MB
```

### Image Veränderung
Nachfolgend sind die Veränderung des `debian:stretch-slim` Image zu dem neu erstellten `cowsay:1-0` Image ersichtlich.

#### docker history
Mit `docker hostory` lassen sich die Layer eines Images anzeigen. Gut ist hier der zusätzlich Layer  im `cowsay:1-0` Image ersichtlich. Die grösse von 58.7MB entspricht der zusätzlich installierter Softwar inklusive etwas Overhead. 

```
$ docker history debian:stretch-slim
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
0af60a5c6dd0        12 days ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           12 days ago         /bin/sh -c #(nop) ADD file:e4bdc12117ee95eaa…   101MB

$ docker history cowsay:1-0
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
3394945165c3        2 minutes ago       bash                                            58.7MB
0af60a5c6dd0        12 days ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           12 days ago         /bin/sh -c #(nop) ADD file:e4bdc12117ee95eaa…   101MB
```
### Container Image *cowsay:1-0* anwenden

Das erstellt `cowsay:1-0` Image kann nun angewendet werden. Es beinhaltet zusätzlich die Installierte Software `cowsay` und `fortune`. Dies können beim Starten des Containers als Argumente zur Ausführung übergeben werden.

```
$ docker run cowsay:1-0 /usr/games/cowsay "muuh - cowsay:1-0"
 ______
< muuh >
 ------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```


## Image mit Dockerfile erstellen

### Dockerfile
Das `Dockerfile` kann mit einem beliebigen Texteditor erstellt werden. Das Dockerfile beginnt immer mit `FROM` gefolgt vom Baseimage welches für das künftige Image als Grundlage verwendet wird. Die weiteren Zeilen definieren alle weiteren Anweisungen für das neue Image. In diesem Fall werden genau diejenigen Kommandos mit `RUN` definiert, welche zuvor bei der manuellen Modifikation am laufenden Container verwendet wurden.

```
$ vi Dockerfile
FROM debian:stretch-slim
RUN apt-get update
RUN apt-get install -y cowsay fortune
```

### Docker Image builden
Das Kommando `docker build` erwartet im selben Verzeichnis wo der Befehla aufgerufen wurde ein `Dockerfile`. Wurde ein abweichender Name verwendet, muss diese `docker build` angegeben werden.

Mit der Option -t wird der Name des erzeugten Images angegeben. Wichtig ist der abschliessende `.`, dieser bedeutet, dass das Dockerfile im aktuellen Verzeichnis gesucht wird.

```
$ docker build -t cowsay:1-1 .
```
Nun steht das neu erstellte Image `cowsay:1-1` lokal zur Verfügung.

```
$ docker images
REPOSITORY   TAG            IMAGE ID       CREATED             SIZE
cowsay       1-1            797220228309   4 minutes ago       114MB
cowsay       1-0            84321b24ac87   About an hour ago   114MB
debian       stretch-slim   ab15bb5b14e4   10 days ago         55.4MB
```



### Container Image *cowsay:1-1* anwenden

```
$ docker run cowsay:1-1 /usr/games/cowsay "muuh - cowsay:1-1"
 ______
< muuh >
 ------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Docker Image um Entrypoint erweiteren

Ein `ENTRYPOINT` definiert den Startpunkt eines Containers. Wird wie in diesem Beispiel `ENTRYPOINT ["/usr/games/cowsay"]` definiert, startet der Container direkt das Programm `cowsay` und es muss lediglich noch der Input an `cowsay` übergeben werden.

```` 
$ vi Dockerfile
FROM debian:stretch-slim
RUN apt-get update && apt-get install -y cowsay fortune
ENTRYPOINT ["/usr/games/cowsay"]
```` 

### Docker Image builden
    $ docker build -t cowsay:1-2 .


### execute *cowsay* über ENTRYPOINT
````
# docker run cowsay:1-2 "muuh - cowsay:1-2"
 ______
< muuh >
 ------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
root@ubuntu-xenial:~#


````

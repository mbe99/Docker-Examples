# cowsay - Image erstellen

## Debian Container starten

Container *cowsay* starten und eine `bash` aufrufen. 

```
# docker run -it --name cowsay --hostname cowsay debian:bookworm-slim bash
root@cowsay:/# exit
```

Container *cowsay* stopen (durch exit in der `bash`)




## Im Container die Software *cowsay* und *fortune* installiern (Container modifizieren)

Container *cowsay* starten

```
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

testen im Container

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

## Veränderungen anzeigen

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

## *docker commit* - Image von modifiziertem Cowsay-Container erstellen

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
debian       bookworm-slim  ab15bb5b14e4   10 days ago      55.4MB
```

## Image Veränderung

Nachfolgend sind die Veränderungen des `debian:bookworm-slim` Image zu dem neu erstellten `cowsay:1-0` Image ersichtlich.

### docker history

Mit `docker history` lassen sich die Layer eines Images anzeigen. Gut ist hier der zusätzlich Layer  im `cowsay:1-0` Image ersichtlich. Die grösse von 69.7MB entspricht der zusätzlich installierter Software inklusive etwas Overhead. Da die Veränderungen in der `bash` erfolgten, wird dies unter *CREATED BY* entsprechend als `bash` ausgewiesen.

```
$ docker history debian:bookworm-slim
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
e7d7f06a08a8   9 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago   /bin/sh -c #(nop) ADD file:ba1250b6ecd5dd09d…   74.8MB
root@docker:~/Docker-Examples/cowsay# docker history cowsay:1-0

$ docker history cowsay:1-0
IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
429de9b79a6b   About a minute ago   bash                                            69.7MB
e7d7f06a08a8   9 days ago           /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago           /bin/sh -c #(nop) ADD file:ba1250b6ecd5dd09d…   74.8MB
```

## Neues Container Image *cowsay:1-0* anwenden

Das erstellte `cowsay:1-0` Image kann nun angewendet werden. Es beinhaltet die zusätzlich installierte Software `cowsay` und `fortune`. Diese können beim Starten des Containers als Argumente zur Ausführung übergeben werden.

```
$ docker run cowsay:1-0 /usr/games/cowsay "muuh - cowsay:1-0"
 ___________________
< muuh - cowsay:1-0 >
 -------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```


## Image mit Dockerfile erstellen

### Dockerfile

Das `Dockerfile` kann mit einem beliebigen Texteditor erstellt werden. Das Dockerfile beginnt immer mit `FROM` gefolgt vom Baseimage, welches für das künftige Image als Grundlage verwendet wird. Die folgenden Zeilen definieren alle weiteren Anweisungen für das neue Image. In diesem Fall werden genau diejenigen Kommandos mit `RUN` definiert, welche wir zuvor bei der manuellen Modifikation im laufenden Container verwendet hatten.

> Der Dateiname `Dockerfile` ist *case-sensitive*

```
$ vi Dockerfile
FROM debian:bookworm-slim
RUN apt-get update
RUN apt-get install -y cowsay fortune
```

## *docker build* - Image erstellen

Das Kommando `docker build` erwartet im selben Verzeichnis ein `Dockerfile`. Wird ein abweichender Name verwendet, muss dies `docker build` mit der Option `-f <file>` angegeben werden.

Mit der Option -t wird der Name des erzeugten Images angegeben. Wichtig ist der abschliessende `.` damit `docker build` das `Dockerfile`im aktuellen Verzeichniss sicht. Ohne diesen müsste der komplette Pfad zum Dockerfile angegeben werden.

```
$ docker build -t cowsay:1-1 .
```
Nun steht das neu erstellte Image `cowsay:1-1` lokal zur Verfügung.

```
$ docker images
REPOSITORY   TAG            IMAGE ID       CREATED             SIZE
cowsay       1-1            797220228309   4 minutes ago       114MB
cowsay       1-0            84321b24ac87   About an hour ago   114MB
debian       bookworm-slim  ab15bb5b14e4   10 days ago         55.4MB
```



### Container Image *cowsay:1-1* anwenden

```
$ docker run cowsay:1-1 /usr/games/cowsay "muuh - cowsay:1-1"
 ___________________
< muuh - cowsay:1-1 >
 -------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Image mit *Entrypoint* erweiteren

Der `ENTRYPOINT` definiert den Startpunkt eines Containers. Wird wie in diesem Beispiel `ENTRYPOINT ["/usr/games/cowsay"]` definiert, startet der Container direkt das Programm `cowsay` und es muss lediglich noch der Input an `cowsay` übergeben werden.

```` 
$ vi Dockerfile
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y cowsay fortune
ENTRYPOINT ["/usr/games/cowsay"]
```` 

Neues Image erstellen

```
$ docker build -t cowsay:1-2 .
```


## Container *cowsay* mit *ENTRYPOINT* ausführen

```
# docker run cowsay:1-2 "muuh - cowsay:1-2"
 ___________________
< muuh - cowsay:1-2 >
 -------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

# cowsay

## Container stoppen 

alle laufenden Conatiner stoppen

```
$ docker stop `docker ps -q`
```

alle gestoppten Container removen

```
$ docker rm `docker ps -a -q`
```

alle laufenden Container stoppen und removen

```
$ docker stop `docker ps -q` && docker rm `docker ps -a -q`
```


## named Debian Container starten

Docker Container starten und eine **bash** aufrufen. 

```
# docker run -it --name cowsay --hostname cowsay debian:stretch-slim bash
root@cowsay:/# exit
exit
```

    $ docker history debian:stretch-slim

### reconnect Container - Install cowsaw und fortune im Container

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

### Docker Image vom Container erstellen

```
$ docker commit cowsay cowsay:1-0
sha256:3394945165c33c08027a694632a9fad04b358764f33a83c8aa9015b25111d90b

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
cowsay              1-0                 3394945165c3        30 seconds ago      159MB
```

### Image Veränderung Debian zu Cowsay

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

### execute 'cowsay' mit Image cowsay:1-0

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

edit  Dockerfile 

    $ vi Dockerfile

```
FROM debian:stretch-slim
RUN apt-get update && apt-get install -y cowsay fortune
```

### build Docker Image
    $ docker build -t cowsay:1-1 .

### execute 'cowsay' mit Image cowsay:1-1

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

Add ENTRYPOINT zum Dockerfile

    $ vi Dockerfile

```` 
$ vi Dockerfile
FROM debian:stretch-slim
RUN apt-get update && apt-get install -y cowsay fortune
ENTRYPOINT ["/usr/games/cowsay"]
```` 

### Docker Image builden
    $ docker build -t cowsay:1-2 .


### execute 'cowsay' über ENTRYPOINT
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

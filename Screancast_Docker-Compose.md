# Beispiele aus Screen Cast

## Portainer

### Commad Line

`docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer`

### Docker-Compase

Datei `portainer.yml` 

```
version: '3'

services:
  portainer:
    image: portainer/portainer
    command: -H unix:///var/run/docker.sock
    restart: always
    ports:
      - 9000:9000
      - 8000:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
  ```
  
  Starten mit 
  
  `docker-compose up -f portainer.yml -d`
  

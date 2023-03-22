# Docker-Mapserver

A dockerized mapserver for CosmoScout [csp-lod bodies.](https://github.com/cosmoscout/cosmoscout-vr/tree/main/plugins/csp-lod-bodies#readme)

## To build the docker image:
``` console
docker buildx build . -t image_name
```
## To run a container:

```console
docker run -p 8080:80 \ 
-v "$(pwd)":/storage/mapserver-datasets \  
image_name
```
The command above runs a container, binds `localhosts port 8080 to containers port 80`, and `mounts the dataset in the pwd to containers  /storage/mapserver-datasets `directory.

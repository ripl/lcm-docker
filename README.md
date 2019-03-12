# LCM in Docker

[![Build Status](http://jenkins.box0.afdaniele.com/job/Docker%20AutoBuild%20-%20lcm/badge/icon)](http://jenkins.box0.afdaniele.com/job/Docker%20AutoBuild%20-%20lcm/)

This repo contains all you need in order to use LCM inside a Docker container.

**NOTE:** Due to the presence of a virtualization layer when running linux
images in Docker for Mac, it is not possible to exchange messages between the
container and the Mac host. For further info about this issue, check the section
[Run on Mac](#run-on-mac) below.


## How to build the Image given the DockerFile

Move to the main directory of this repository and run

```
docker build -t ripl/lcm:latest ./
```


## How to run the Docker container

To deploy a new container that can talk to a (Linux) host and other Docker
containers via LCM, run

```
docker run -it --net=host ripl/lcm:latest
```

## Tests

| Host | Containers | Tunnel | Executed | Works? |
|------|------------|--------|----------|--------|
| Mac  | 1 | No | :heavy_check_mark: | :heavy_multiplication_x: |
| Linux  | 1 | No | :heavy_check_mark: | :heavy_check_mark: |
| Linux  | 2 | No | :heavy_check_mark: | :heavy_check_mark: |
| Mac  | 1 | Yes | :heavy_multiplication_x: | TBA |
| Mac  | 2 | Yes | :heavy_multiplication_x: | TBA |


## Run on Mac

As of August 2018, the driver used by Docker to virtualize the network on Mac
does not implement multicasting, thus it is not possible to exchange data between
Mac host and Docker linux using LCM.

Nevertheless, there is still hope. A third-party implementation of the network
layer for Docker seem to be supporting UDP multicasting. It is called
[Weave Net Docker Network Plugin](https://www.weave.works/docs/net/latest/install/plugin/plugin-how-it-works/).

### A possible workaround

A possible (still not tested) workaround could be to deploy a special LCM Docker
container. Such container would be based on the base LCM image defined above, but
it will also have an entrypoint script that deploys an LCM tunnel with the server
listening on the port `XXXX`. At his point the Mac host could run the LCM tunnel
client and receive/send messages transparently.

I'm still not sure whether the Docker `bridged` network between two or more
containers on Mac supports multicast (this should be tested).
Regardless of this issue, the workaround should work nicely when there is only
one LCM container running on a Mac host. In this case, the same LCM container
would deploy the tunnel. 

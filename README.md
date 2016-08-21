# DebBuilder

This Dockerbuild creates a debian image with the necessary dependancies to build ceratain pieces of software that I use.

## Building the images

You can build this image by running:

```sh
sudo docker build --rm --tag deb-builder .
```

## Running the deb-builder

You can specify which  deb you want to build by execution the build scripts that were included in the Dockerfile.

```sh
sudo docker run --rm -v '/tmp:/tmp' deb-builder bash build_urxvt
```

The built deb file will be located in your `/tmp` folder

### TODO

        - make an entrypoint script to handle input args so you can just pass the name of the application you want a deb for

# Modification

Forked from https://github.com/subzero79/cups-docker to have minimal drivers and include the zj58 driver from https://github.com/klirichek/zj-58 for POS printer

The base image is ubuntu:jammy

This is intended for rpi docker as the bullseye default cups server prints the receipts misaligned

# CUPS-docker

Run a CUPS print server on a remote machine to share USB printers over WiFi. Built primarily to use with Raspberry Pis as a headless server, but there is no reason this wouldn't work on `amd64` machines. Tested and confirmed working on a Raspberry Pi 3B+ (`arm/v7`) and Raspberry Pi 4 (`arm64/v8`).

## Usage

Quick start with default parameters

```sh
docker run -d -p 631:631 --device /dev/bus/usb --name cups anujdatar/cups
```

Customizing your container

```sh
docker run -d --name cups \
    --restart unless-stopped
    -p 631:631 \
    --device /dev/bus/usb \
    -e CUPSADMIN=batman \
    -e CUPSPASSWORD=batcave_password \
    -e TZ="America/Gotham"
```

> Note: :P make sure you use valid TZ string, this is just a joke. Also changing the default username and password is highly recommended.

### Parameters and defaults

-   `port` -> default cups network port `631:631`. Change not recommended unless you know what you're doing
-   `device` -> used to give docker access to USB printer. Default passes the whole USB bus `/dev/bus/usb`, in case you change the USB port on your device later. change to specific USB port if it will always be fixed, for eg. `/dev/bus/usb/001/005`.

#### Optional parameters

-   `name` -> whatever you want to call your docker image. using `cups` in the example above.

Environment variables that can be changed to suit your needs, use the `-e` tag
| # | Parameter | Default | Type | Description |
| - | ------------ | ------------------ | ------ | --------------------------------- |
| 1 | TZ | "America/New_York" | string | Time zone of your server |
| 2 | CUPSADMIN | admin | string | Name of the admin user for server |
| 3 | CUPSPASSWORD | password | string | Password for server admin |

### docker-compose

```yaml
version: "3"
services:
    cups:
        image: anujdatar/cups
        container_name: cups
        restart: unless-stopped
        ports:
            - "631:631"
        devices:
            - /dev/bus/usb:/dev/bus/usb
        environment:
            - CUPSADMIN=batman
            - CUPSPASSWORD=batcave_password
            - TZ="America/Gotham"
```

## Server Administration

You should now be able to access CUPS admin server using the IP address of your headless computer/server http://192.168.xxx.xxx:631, or whatever. If your server has avahi-daemon/mdns running you can use the hostname, http://printer.local:631. (IP and hostname will vary, these are just examples)

If you are running this on your PC, i.e. not on a headless server, you should be able to log in on http://localhost:631

## Thanks

Based on the work done by **RagingTiger**: [https://github.com/RagingTiger/cups-airprint](https://github.com/RagingTiger/cups-airprint)

## TODO

Make CUPS configs persistent, in case you need to delete container or migrate to new system

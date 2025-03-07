# Docker-API2SBS

- [Docker-API2SBS](#docker-api2sbs)
  - [What is it?](#what-is-it)
  - [How to install and configure it](#how-to-install-and-configure-it)
  - [LICENSE](#license)

## What is it?

This repository is to create a container that retrieves JSON data from the aggregators that expose an ADSBExchange-V2 or aircraft.json -style API and sends this data to a server in SBS format.

The container can get the aircraft for multiple "spots" (Lat/Lon/Dist combinations) for a (single) API. If you want to collect data across multiple APIs (for example, from ADSBExchange, Airplanes.live, and adsb.fi), you would have to spin up a separate container instance for each of these APIs.

Currently, only "pull" connections over REST (to get data from the source), and SBS (BaseStation) format "push" connections (i.e., by creating an outbound connection) to your Ultrafeeder/Readsb/dump1090 instance are supported.

## How to install and configure it

See the included [docker-compose.yml](docker-compose.yml) file for info on how to define and configure the container

## LICENSE

This software is licensed under the Gnu Public License, V3. See [LICENSE](LICENSE).
Copyright 2025 by Ramon F. Kolb, kx1t

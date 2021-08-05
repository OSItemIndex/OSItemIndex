# OSItemIndex

Centralizes multiple OSRS third-party pricing and item API's such as [PH01L's OSRSBox](https://github.com/osrsbox) and the [OSRS wiki communtie, in partnership with RuneLite, realtime-prices API](https://oldschool.runescape.wiki/w/RuneScape:Real-time_Prices) to present a very fast and powerful API, with a handy website

# Microservice architecture

### Services

OSItemIndex is designed as microservices and implemented as a docker-compose project

* OSItemIndex.API
* OSItemIndex.Updater
* OSItemIndex.UI

### Components

* [traefik](https://hub.docker.com/_/traefik) - Reverse proxy and gateway service, provides load balancing and offers middlware
* [supabase/postgres](https://hub.docker.com/r/supabase/postgres) - PostgreSQL database service
* [supabase/realtime](https://hub.docker.com/r/supabase/realtime) - PostgreSQL websocket service

### [`See docker-compose.yml`](https://github.com/OSItemIndex/OSItemIndex/blob/main/docker-compose.yml)

# Packages

### OSItemIndex.API
---
```ruby
docker pull ghcr.io/ositemindex/api:latest
```

### OSItemIndex.Updater
---
```ruby
docker pull ghcr.io/ositemindex/updater:latest
```

### OSItemIndex.UI
---
```ruby
docker pull ghcr.io/ositemindex/ui:latest
```


# Development

[`docker-compose.dev.yml`](docker-compose.dev.yml) is implemented as a quick development environment to work in. It'll deploy all services and attach the source directory as a volume. Each service utilizes `dotnet watch` or `react-scripts start` for hot-reloading. Any source file changes made can be immediately seen, on any service

* `localhost` is used as the domain
* [`.env`](.env) is used, but note `REALTIME_JWT` and `WEB_DOMAIN` aren't used in `docker-compose.dev.yml`

# Devops

OSItemIndex utilizes GitHub actions to build and deploy docker images to the OSItemIndex organization

* Each service contains a [basic build-and-publish dockerfile workflow](https://github.com/OSItemIndex/OSItemIndex.API/blob/master/.github/workflows/build-publish-dockerfile.yml)
* The main OSItemIndex repository contains [individual publish[service] workflows](.github/workflows) and [a publish[all] workflow](.github/workflows/publish-all.yml) that dispatches a build-and-publish event to each service repository by utilizing strategy matrix's, and waits for each workflow to finish
* The OSItemIndex repository serves as a central deployment tool through GitHub actions
* [GitHubs `REST` API allows creating `repository_dispatch` events](https://docs.github.com/en/rest/reference/repos#create-a-repository-dispatch-event), so theoritically deployment can be controlled with `http requests` externally with a `personal access token`

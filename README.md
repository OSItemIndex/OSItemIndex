# OSItemIndex

Centralizes multiple OSRS third-party pricing and item API's such as [PH01L&#39;s OSRSBox](https://github.com/osrsbox) and the [OSRS wiki community, in partnership with RuneLite, realtime-prices API](https://oldschool.runescape.wiki/w/RuneScape:Real-time_Prices) to provide a very fast and powerful API

# Microservice architecture

OSItemIndex is designed as docker microservices and implemented as a docker-compose project

### Services

- [OSItemIndex.API](https://github.com/OSItemIndex/OSItemIndex.API) - REST API
- [OSItemIndex.Updater](https://github.com/OSItemIndex/OSItemIndex.Updater) - Conditionally pools and updates data from third party API's
- [OSItemIndex.UI](https://github.com/OSItemIndex/OSItemIndex.UI) - Frontend website to visualize and build queries you can plug into the API

### Components

- [traefik](https://hub.docker.com/_/traefik) - Reverse proxy and gateway service, also provides load balancing and middlware
- [supabase/postgres](https://hub.docker.com/r/supabase/postgres) - PostgreSQL database service
- [supabase/realtime](https://hub.docker.com/r/supabase/realtime) - PostgreSQL websocket service

#### [`See docker-compose.yml`](https://github.com/OSItemIndex/OSItemIndex/blob/main/docker-compose.yml)

# Packages

### OSItemIndex.API

```lex
docker pull ghcr.io/ositemindex/api:latest
```

### OSItemIndex.Updater

```lex
docker pull ghcr.io/ositemindex/updater:latest
```

### OSItemIndex.UI

```lex
docker pull ghcr.io/ositemindex/ui:latest
```

# Development

[`docker-compose.dev.yml`](docker-compose.dev.yml) is implemented as a quick development environment to work in. It'll deploy all services and attach the source directory as a volume. Each service utilizes `dotnet watch` or `react-scripts start` for hot-reloading. Any source file changes made can be immediately seen, on any service

- [`.env`](.env) is used by default
- `localhost` is used as the dev domain
  - `localhost` is used by [OSItemIndex.UI](https://github.com/OSItemIndex/OSItemIndex.UI)
  - `localhost/api` and `localhost/swagger` is used by [OSItemIndex.API](https://github.com/OSItemIndex/OSItemIndex.API)
  - `localhost/api/services` is used by [OSItemIndex.Updater](https://github.com/OSItemIndex/OSItemIndex.Updater)
  - `localhost:POSTGRES_PORT` (defined in [`.env` 5432 by default](.env)) can be used to connect to the postgres db
    - Default credentials found in [`.env`](.env)

* Local development does **not** use `https`

# Devops

OSItemIndex utilizes GitHub actions to build and deploy docker images to the OSItemIndex organization

- Each service repository contains [a basic build-and-publish dockerfile workflow](https://github.com/OSItemIndex/OSItemIndex.API/blob/master/.github/workflows/build-publish-dockerfile.yml)
- The main OSItemIndex repository contains [individual publish[service] workflows](.github/workflows) and [a publish[all] workflow](.github/workflows/publish-all.yml) that dispatches a build-and-publish event to each service repository by utilizing strategy matrix's, and waits for each workflow to finish
- The OSItemIndex repository serves as a central deployment tool through GitHub actions
- [GitHubs `REST` API allows creating `repository_dispatch` events](https://docs.github.com/en/rest/reference/repos#create-a-repository-dispatch-event), so theoritically deployment can be controlled with `http requests` externally with a `personal access token`


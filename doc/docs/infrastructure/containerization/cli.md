# Docker CLI

## Docker Application

| Command               | Description                                                                          |
|-----------------------|--------------------------------------------------------------------------------------|
| docker app bundle     | Create a CNAB invocation image and bundle.json for the application                   |
| docker app completion | Generates completion scripts for the specified shell (bash or zsh)                   |
| docker app init       | Initialize Docker Application definition                                             |
| docker app inspect    | Shows metadata, parameters and a summary of the Compose file for a given application |
| docker app install    | Install an application                                                               |
| docker app list       | List the installations and their last known installation result                      |
| docker app merge      | Merge a directory format Docker Application definition into a single file            |
| docker app pull       | Pull an application package from a registry                                          |
| docker app push       | Push an application package to a registry                                            |
| docker app render     | Render the Compose file for an Application Package                                   |
| docker app split      | Split a single-file Docker Application definition into the directory format          |
| docker app status     | Get the installation status of an application                                        |
| docker app uninstall  | Uninstall an application                                                             |
| docker app upgrade    | Upgrade an installed application                                                     |
| docker app validate   | Checks the rendered application is syntactically correct                             |
| docker app version    | Print version information                                                            |

## Docker builder

| Command              | Description                      |
|----------------------|----------------------------------|
| docker builder build | Build an image from a Dockerfile |
| docker builder prune | Remove build cache               |

## Docker buildx

| Command                  | Description                            |
|--------------------------|----------------------------------------|
| docker buildx bake       | Build from a file                      |
| docker buildx build      | Start a build                          |
| docker buildx create     | Create a new builder instance          |
| docker buildx du         | Disk usage                             |
| docker buildx imagetools | Commands to work on images in registry |
| docker buildx inspect    | Inspect current builder instance       |
| docker buildx ls         | List builder instances                 |
| docker buildx prune      | Remove build cache                     |
| docker buildx rm         | Remove a builder instance              |
| docker buildx stop       | Stop builder instance                  |
| docker buildx use        | Set the current builder instance       |
| docker buildx version    | Show buildx version information        |

## Docker compose

| Command                | Description                                              |
|------------------------|----------------------------------------------------------|
| docker compose build   | Build or rebuild services                                |
| docker compose convert | Converts the compose file to platform’s canonical format |
| docker compose create  | Creates containers for a service.                        |
| docker compose down    | Stop and remove containers, networks                     |
| docker compose events  | Receive real time events from containers.                |
| docker compose exec    | Execute a command in a running container.                |
| docker compose kill    | Force stop service containers.                           |
| docker compose logs    | View output from containers                              |
| docker compose ls      | List running compose projects                            |
| docker compose pause   | pause services                                           |
| docker compose ps      | List containers                                          |
| docker compose pull    | Pull service images                                      |
| docker compose push    | Push service images                                      |
| docker compose rm      | Removes stopped service containers                       |
| docker compose run     | Run a one-off command on a service.                      |
| docker compose start   | Start services                                           |
| docker compose stop    | Stop services                                            |
| docker compose top     | Display the running processes                            |
| docker compose unpause | unpause services                                         |
| docker compose up      | Create and start containers                              |

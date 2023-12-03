# MongoDB docker image

<a href="https://hub.docker.com/_/mongo" alt="Docker hub repository" target="_blank">
    <img alt="Docker Stars" src="https://img.shields.io/docker/stars/_/mongo">
</a>

## Environment variables / startup scripts

!!! danger
    Any pre-existing DB will be left untouched, so env. var. have no effect

- `MONGO_INITDB_ROOT_USERNAME`
- `MONGO_INITDB_ROOT_PASSWORD`, when used with `..._USERNAME`, creates user in the admin auth DB with root role
- `MONGO_INITDB_DATABASE` specify the name of a DB used in initialization scripts

!!! info
    Files can be passed for sensitive informatin by appending `_FILE` a env. var., e.g.:
    ```MONGO_INITB_ROOT_PASSWORD_FILE='/var/mongodb_root_secret'
    ```

## Initialization

- optional and used for more complex setup
- all files located at `/dock-entrypoint-initdb.d/` with extension `.js` and `.sh` will be executed.
- execution in alphabetical order
- `.js` files will be executed by mongo using `MONGO_INIT_DATABASE` otherwise 'test'

## Connection

Either with dockerized shell or with the OS mongo shell.

```bash
$ docker exec -it <CONTAINER_NAME> mongo
$ mongo --port 27017 -u <USERNAME> -p <PASSWORD> --authenticatioinDatabase admin
```

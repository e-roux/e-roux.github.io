# PostgreSQL

<img src='https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg' class='titleLogo' alt='logo'/>

Connect From Your Local Machine to a PostgreSQL Database in Docker

https://medium.com/better-programming/connect-from-local-machine-to-postgresql-docker-container-f785f00461a7


Linux downloads (Ubuntu)

https://www.postgresql.org/download/linux/ubuntu/


http://zetcode.com/db/postgresqlc/

## Docker

<a href="https://hub.docker.com/_/postgres" alt="Docker hub repository" target="_blank">
	<img alt="Docker Stars" src="https://img.shields.io/docker/stars/_/postgres">
</a>

Starting a docker container requires `POSTGRES_PASSWORD` to be set as
environement variable. If `POSTGRES_DB` is not set, it is defaulted to
`POSTGRES_USER` value.

```shell
docker run -i -d -p 5432:5432 -e POSTGRES_PASSWORD=password postgres:latest
```

## PostgreSQL informational commands

Basic commands to survive on PostgreSQL.

|    Command   | Description                                   |
|:------------:|-----------------------------------------------|
|     `\l`     | list databases                                |
|   `\c <DB>`  | connect to a database                         |
|     `\d`     | list tables, views, and sequences             |
| `\d <TABLE>` | describe named table, view, sequence or index |
|     `\dt`    | list tables                                   |
|     `\di`    | list indexes                                  |
|     `\dv`    | list views                                    |
|     `\q`     | quit application                              |

|---------------------------------------+--------------------------------------------------|
| Command                               | Description                                      |
| ------------------------------------- | ------------------------------------------------ |
| \#                                    | Refresh auto-completions.                        |
| \?                                    | Show Commands.                                   |
| \T [format]                           | Change the table format used to output results   |
| \c[onnect] database_name              | Change to a new database.                        |
| \conninfo                             | Get connection details                           |
| \copy [tablename] to/from [filename]  | Copy data between a file and a table.            |
| \d[+] [pattern]                       | List or describe tables, views and sequences.    |
| \dD[+] [pattern]                      | List or describe domains.                        |
| \dT[S+] [pattern]                     | List data types                                  |
| \db[+] [pattern]                      | List tablespaces.                                |
| \df[+] [pattern]                      | List functions.                                  |
| \di[+] [pattern]                      | List indexes.                                    |
| \dm[+] [pattern]                      | List materialized views.                         |
| \dn[+] [pattern]                      | List schemas.                                    |
| \ds[+] [pattern]                      | List sequences.                                  |
| \dt[+] [pattern]                      | List tables.                                     |
| \du[+] [pattern]                      | List roles.                                      |
| \dv[+] [pattern]                      | List views.                                      |
| \dx[+] [pattern]                      | List extensions.                                 |
| \e [file]                             | Edit the query with external editor.             |
| \h                                    | Show SQL syntax and help.                        |
| \i filename                           | Execute commands from file.                      |
| \l[+] [pattern]                       | List databases.                                  |
| \n[+] [name] [param1 param2 ...]      | List or execute named queries.                   |
| \nd [name]                            | Delete a named query.                            |
| \ns name query                        | Save a named query.                              |
| \o [filename]                         | Send all query results to file.                  |
| \pager [command]                      | Set PAGER. Print the query results via PAGER.    |
| \pset [key] [value]                   | A limited version of traditional \pset           |
| \q                                    | Quit pgcli.                                      |
| \refresh                              | Refresh auto-completions.                        |
| \sf[+] FUNCNAME                       | Show a function's definition.                    |
| \timing                               | Toggle timing of commands.                       |
| \x                                    | Toggle expanded output.                          |
| quit                                  | Quit pgcli.                                      |
|---------------------------------------+--------------------------------------------------|

## Load data from cli/files


```sql
 -- Input from stdin
 echo """1 | Paul  |  32 | California|  20000
  2 | Allen |  25 | Texas     |  15000
  3 | Teddy |  23 | Norway    |  20000
  4 | Mark  |  25 | Rich-Mond |  65000
  5 | David |  27 | Texas     |  85000
  6 | Kim   |  22 | South-Hall|  45000
  7 | James |  24 | Houston   |  10000""" | \
  psql -U postgres -h localhost -p 5432 -d mydb \
  -c "COPY mytable FROM STDIN DELIMITER '|'"

-- Or from a file
CAT mydata.csv | psql -U postgres -c "COPY mytable FROM STDIN"
```


## Common Table Expression (CTE)

A CTE is a temporary result set that can be referenced within another SQL
statement, e.g. `SELECT`, `INSERT`, `UPDATE`, `DELETE`.


## `generate_series`

 <badge-doc href='https://www.postgresql.org/docs/current/functions-srf.html' logo="postgresql"></badge-doc>
Works with types `int`, `bigint`, `numeric`, `timestamp` w. and w.o. time
zone.

??? Examples

    ```sql

        SELECT * FROM generate_series(2,4);
        generate_series
        -----------------
                    2
                    3
                    4
        (3 rows)

        SELECT * FROM generate_series(5,1,-2);
        generate_series
        -----------------
                    5
                    3
                    1
        (3 rows)

        SELECT * FROM generate_series(4,3);
        generate_series
        -----------------
        (0 rows)

        SELECT generate_series(1.1, 4, 1.3);
        generate_series
        -----------------
                    1.1
                    2.4
                    3.7
        (3 rows)

        -- this example relies on the date-plus-integer operator:
        SELECT current_date + s.a AS dates FROM generate_series(0,14,7) AS s(a);
        dates
        ------------
        2004-02-05
        2004-02-12
        2004-02-19
        (3 rows)

        SELECT * FROM generate_series('2008-03-01 00:00'::timestamp,
                                    '2008-03-04 12:00', '10 hours');
        generate_series
        ---------------------
        2008-03-01 00:00:00
        2008-03-01 10:00:00
        2008-03-01 20:00:00
        2008-03-02 06:00:00
        2008-03-02 16:00:00
        2008-03-03 02:00:00
        2008-03-03 12:00:00
        2008-03-03 22:00:00
        2008-03-04 08:00:00
        (9 rows)
    ```

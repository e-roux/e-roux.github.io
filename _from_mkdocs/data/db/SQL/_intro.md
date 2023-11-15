# SQL - Structured Query Language

## Command types

| Name                                   | Description                                             | Example                                     |
|----------------------------------------|---------------------------------------------------------|---------------------------------------------|
| **DDL** - Data Definition Language     | organization of data whithin the DB                     | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`       |
| **DQL** - Data Query Language          | to perform queries on the data                          | `SELECT`                                    |
| **DML** - Data Manipulation Language   | used to retrieve and manipulate data in a relational DB | `SELECT...INTO`, `INSERT INTO... VALUES...` |
| **DCL** - Data Control Language        | user rights and permission                              | `GRANT`, ` REVOKE`                          |
| **TCL** - Transaction Control Language | deals with DB transactions                              | `COMMIT`, `ROLLBACK`, `SAVEPOINT`           |


## SQL within Python


For sql like data access, [SQLAlchemy](https://docs.sqlalchemy.org/en/13/index.html) consists of two distinct components, known as the **Core** (abstraction toolkit) and an optional but convenient **ORM** (Object Relational Mapper).

For analytics, [Pandas](https://pandas.pydata.org/docs/index.html) provides facili tes and loads the data into the memory of the local host, [Ibis](https://docs.ibis-project.org/) leaves the data in its storage, and performs the computations there

For SQL command in jupyter, see the [SQL jupyter magic](https://github.com/catherinedevlin/ipython-sql) and a [notebook example](https://github.com/satybald/ipython-notebooks/blob/master/MagicsSQL.ipynb)

## Sort order

### Collation

String sorting is done on a character-by-character basis but custom alphanumeric values is [possible]( https://www.essentialsql.com/use-sql-server-to-sort-alphanumeric-values/ ).

!!! Info ""

    A DBMS uses a collating sequence, or collation, to determine the order in
    which characters are sorted. The collation defines the order of precedence
    for every character in your character set. Your character set depends on the
    language that you’re using—European languages (a Latin character set),
    Hebrew (the Hebrew alphabet), or Chinese (ideographs), for example. The
    collation also determines case sensitivity (is ‘A’ < ‘a’?), accent
    sensitivity (is ‘A’ < ‘À’ ?), width sensitivity (for multibyte or Unicode
    characters), and other factors such as linguistic practices. The SQL
    standard doesn’t define particular collations and character sets, so each
    DBMS uses its own sorting strategy and default collation… Search your DBMS
    documentation for collation or sort order.

    Source: Fehily, Chris - [ SQL VIsual QuickStart Guide, 3rd Edition ](http://www.peachpit.com/articles/article.aspx?p=1276352&seqNum=4).


### Missing values

`NULL` values are handled differently on SQL engine, e.g.:

- Impala handles `NULL` as top values
- Hive and MySQL handles `NULL` as lower values.

To override such a behavior, `NULLS FIST` or `NULL LAST` can be specified. This is not supported by all engines. Impala, Hive and PostgreSQL does when MySQL does not. Another possibility to achieve this is to double the sort operation:

```SQL
-- SQL will fist sort by 'col2 IS NULL' which is a boolean, then by 'col2'
SELECT col, col2 FROM table1 ORDER BY col2 IS NULL ASC, col2
```

### Engines limitations

Selection must sometimes include the column on which the is done.

??? Example

    ```SQL
    -- This will not work in Hive
    SELECT col1, col2 FROM table1 ORDER BY col3

    -- Nor this
    SELECT col1, col2 FROM table1 ORDER BY col3 * col4

    -- This will be ok
    SELECT col1, col2, col3, col4 FROM table1 ORDER BY col3 * col4

    -- and this
    SELECT col1, col2, col3 * col4 AS muliplication FROM table1 ORDER BY multiplication
    ```

## Limit

For pagination, sql specific implementations:

!!! Example ""

    ```SQL
    -- For Impala and PostgreSQL
    LIMIT <limit> OFFSET <offset>

    -- For Hive
    Limit <offset>, <limit>

    -- MySQL supports both
    -- some use SKIP
    ```

!!! Danger

    Without `ORDER BY`, order is not deterministic: some row could be displayed
    multiple times or missing as selection is arbitrary. Impala require `ORDER BY`
    when using `OFFSET`


## Select

Syntaxic order

SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY, LIMIT

Execution order (in general)

FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT

### Shortcut


!!! Danger "Order by position"

    It is possible in some engine to specify the position or the column to apply the order on. This is not supported by every engine and will not raise an error.

    ```SQL
    -- This will order by the 3rd column
    SELECT col1, col2, col3 FROM table1 ORDER BY 3
    ```

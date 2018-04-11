[![CircleCI](https://circleci.com/gh/kos59125/local-presto.svg?style=svg)](https://circleci.com/gh/kos59125/local-presto)

# local-presto

Run Presto on your local machine

## Setup

### Pull Docker image

```bash
$ docker pull kos59125/local-presto
```

### Create your own connection setting

Create your own properties file. See [Connectors on Presto Documentation](https://prestodb.io/docs/current/connector.html) for your help.

For example, if you would like to connect MySQL hosted on db.example.com, you create `mysql.properties` as the following:

```properties
connector.name=mysql
connection-url=jdbc:mysql://db.example.com:3306
connection-user=dbuser
connection-password=dbpassword
```

## Run container

You must mount your properties file onto `/opt/presto/etc/catalog` at startup.

Example:

```bash
$ docker run -v /path/to/mysql.properties:/opt/presto/etc/catalog/mysql.properties:ro -it kos59125/local-presto
```

The entrypoint shell script of Presto is same as the Presto CLI.
You can specify options of Presto CLI like `--catalog` and `--output-format`.

Examples:

```bash
$ docker run -v ... -it kos59125/local-presto --catalog mysql --schema mydb
```

```bash
$ docker run -v ... kos59125/local-presto --execute "SELECT * FROM mysql.mydb.table LIMIT 100" --output-format CSV_HEADER >out.csv
```

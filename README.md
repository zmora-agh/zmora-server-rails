# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

``` 
sudo apt-get install libpq-dev rabbitmq-server
sudo apt-get install  postgresql-9.6
```

* Configuration

* Database creation
``` postgresql
CREATE USER zmora WITH PASSWORD 'szatan';
CREATE DATABASE zmora-test;
CREATE DATABASE zmora-ror;
GRANT ALL PRIVILEGES ON DATABASE "zmora-test"  to zmora;
GRANT ALL PRIVILEGES ON DATABASE "zmora-ror"  to zmora;
```
* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

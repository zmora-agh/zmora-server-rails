# README

* System dependencies
``` 
sudo apt-get install postgresql-9.6
```

* Database creation
``` postgresql
CREATE USER zmora WITH PASSWORD 'szatan';
CREATE DATABASE "zmora-test";
CREATE DATABASE "zmora-ror";
GRANT ALL PRIVILEGES ON DATABASE "zmora-test" to zmora;
GRANT ALL PRIVILEGES ON DATABASE "zmora-ror" to zmora;
```

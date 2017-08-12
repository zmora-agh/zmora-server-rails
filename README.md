## System dependencies
* Ruby 2.3+
* local PostgreSQL instance
* `libpq-dev` (when `pg` gem fails to build native extension)
* (temporarily) local RabbitMQ instance

## Database creation
``` postgresql
CREATE USER zmora WITH PASSWORD 'szatan';
CREATE DATABASE "zmora-test";
CREATE DATABASE "zmora-ror";
GRANT ALL PRIVILEGES ON DATABASE "zmora-test" to zmora;
GRANT ALL PRIVILEGES ON DATABASE "zmora-ror" to zmora;
```

Typically you will execute this script from `psql` console
(`sudo -u postgres psql`).

## Setting up development environment (Ubuntu)
### Install system packages
```
sudo apt install ruby postgresql libpq-dev rabbitmq-server
```

### Start services
```
sudo systemctl start postgresql
sudo systemctl start rabbitmq-server
```

These services will *NOT* start automatically after reboot, so you need to
start them before development. You can enable services to start automatically
by running:
```
sudo systemctl enable postgresql
sudo systemctl enable rabbitmq-server
```

### Set up database user and create databases
Run `sudo -u postgres psql` then copy-paste script from the database creation
section.

### Install local gems
Run `bin/bundle install --path vendor/bundle`.

### Run database migrations
Run `bin/rails db:migrate RAILS_ENV=development`.

### Start the server
Run `bin/rails s`. The server should be accessible from http://localhost:3001.

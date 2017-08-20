## System dependencies
* Ruby 2.3+
* local PostgreSQL instance
* `libpq-dev` (when `pg` gem fails to build native extension)
* local RabbitMQ instance

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

## Retrying failed DB transactions (requeueing judge results)
Judge results consumed from RabbitMQ queue are persistently stored in database.
When DB transaction fails (e.g. due to DB unavailability, constraint
violation or other errors), source message (judge result) will be moved
to error queue (by default `tasksResultsError`.)

Pending messages can be reprocessed by moving messages from error queue – this
is time where RabbitMQ shovel plugin kicks in. To enable it, type:
```
rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
```
(This command enables GUI management plugin too.)

Now you can move pending messages by running
```
rabbitmqctl set_parameter shovel results '{"src-uri": "amqp://", "src-queue": "taskResultsError", "dest-uri": "amqp://", "dest-queue": "taskResults", "delete-after": "queue-length"}'
```

This command should be run periodically in production environment (e.g. by
`cron`.)

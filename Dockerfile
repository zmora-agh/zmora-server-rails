FROM ruby:2.4.1-jessie

RUN apt-get update \
  && apt-get install -qq -y dirmngr gnupg apt-transport-https ca-certificates --fix-missing --no-install-recommends \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jessie main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \ 
  && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 nginx-extras passenger gettext-base --fix-missing --no-install-recommends

ENV INSTALL_PATH /opt/zmora-server
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ENV RAILS_ENV production
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --deployment

RUN sed -i '/passenger.conf;/s/# //g' /etc/nginx/nginx.conf \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

COPY . .

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/bin/bash", "-c","envsubst < nginx/default.template > /etc/nginx/sites-enabled/default && nginx -g 'daemon off;'"]


FROM ruby:2.7.2-buster

LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"

# Lanza error si el Gemfile no es compatible con Gemfile.lock
RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN rm Gemfile Gemfile.lock

WORKDIR /test
VOLUME /test

CMD ["rake", "test"]
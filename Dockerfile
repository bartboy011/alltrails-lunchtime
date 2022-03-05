FROM ruby:3.1.1

# Ensure our image has all security updates patched
RUN apt-get -y update \
    && \
    apt-get -y upgrade \
    && \
    apt-get dist-upgrade

# Will raise an error if we've updated our Gemfile but not the lockfile
RUN bundle config --global frozen 1

# Ensure our port is always available
EXPOSE 3000

# It's a bad idea to run as root, even in a docker container
RUN addgroup appgroup && adduser --no-create-home --ingroup appgroup --disabled-password --gecos "" appuser

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

USER appuser

COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]
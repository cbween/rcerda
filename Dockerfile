ARG APP_PATH=/srv

FROM ruby:3.3.6

RUN apt-get update && apt-get upgrade
RUN apt-get install -y git build-essential vim less

ARG APP_PATH

RUN mkdir -p $APP_PATH
RUN adduser localuser

USER localuser

WORKDIR $APP_PATH
COPY --chown=localuser ./ .
RUN gem install bundler -v 2.6.1

RUN bundle install

RUN gem build edr_agent_tester.gemspec
RUN gem install edr_agent_tester-0.1.0.gem

USER root
RUN rm -rf $APP_PATH

USER localuser
WORKDIR /home/localuser

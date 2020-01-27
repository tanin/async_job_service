FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y apt-utils build-essential libpq-dev

RUN mkdir /async_job_service
WORKDIR /async_job_service

ADD Gemfile /async_job_service/Gemfile
ADD Gemfile.lock /async_job_service/Gemfile.lock
RUN bundle install

ADD . /async_job_service

EXPOSE 3000

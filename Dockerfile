FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /async_job_service
WORKDIR /async_job_service

ADD Gemfile /async_job_service/Gemfile
ADD Gemfile.lock /async_job_service/Gemfile.lock
RUN bundle install

ADD . /async_job_service

EXPOSE 3000

#CMD RAILS_ENV=${RAILS_ENV} bundle exec rails db:create db:migrate db:seed && bundle exec rails s -p ${PORT} -b '0.0.0.0'

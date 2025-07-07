FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y build-essential cron

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

# COPY ./config/schedule.rb /app/config/schedule.rb
# RUN whenever --clear-crontab && whenever --update-crontab

EXPOSE 3000

CMD cron && rails server -b 0.0.0.0

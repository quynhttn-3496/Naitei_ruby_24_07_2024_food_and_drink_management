FROM ruby:3.2.2
ENV RAILS_ENV=development
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  default-mysql-client \
  nodejs \
  yarn
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

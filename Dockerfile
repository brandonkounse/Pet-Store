FROM ruby:3.1.2
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt-get update && apt-get install -y postgresql-client
RUN bundle install
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

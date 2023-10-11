FROM ruby:3.1.2
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

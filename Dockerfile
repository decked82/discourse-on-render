FROM discourse/base:latest

WORKDIR /var/www/discourse

COPY . .

RUN bundle config set --local deployment true && \
    bundle config set --local without 'test development' && \
    MAKEFLAGS="-j1" bundle install --retry 3

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
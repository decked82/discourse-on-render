FROM discourse/base:2.0.20240116-0051

WORKDIR /var/www

# Клонируем Discourse
RUN git clone https://github.com/discourse/discourse.git \
    && cd discourse \
    && git checkout main \
    && sed -i '/"packageManager"/d' package.json

WORKDIR /var/www/discourse

# Установка зависимостей
RUN bundle config set --local path 'vendor/bundle' \
    && bundle install \
    && yarn install --network-timeout 300000

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
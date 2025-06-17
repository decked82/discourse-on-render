# Используем официальный Ruby-образ
FROM ruby:3.2

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  git \
  curl \
  imagemagick \
  libvips \
  libjemalloc-dev \
  && apt-get clean

# Устанавливаем рабочую директорию
WORKDIR /app

# Клонируем Discourse
RUN git clone https://github.com/discourse/discourse.git . \
  && git checkout main

# Устанавливаем зависимости Ruby
RUN gem install bundler \
  && bundle config set --local path 'vendor/bundle' \
  && bundle install

# Устанавливаем Node-зависимости
RUN yarn install

# Указываем порт
EXPOSE 3000

# Команда запуска
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
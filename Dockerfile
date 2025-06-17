FROM ruby:3.2

RUN apt-get update && apt-get install -y \
  build-essential libpq-dev imagemagick libvips libjemalloc-dev \
  git curl nodejs npm \
  && apt-get clean

WORKDIR /app

# Скачиваем Discourse
RUN git clone https://github.com/discourse/discourse.git .

# Удаляем packageManager, чтобы не мешал
RUN sed -i '/"packageManager"/d' package.json

WORKDIR /app

# Установка Ruby зависимостей
RUN gem install bundler \
  && bundle config set --local path 'vendor/bundle' \
  && bundle install --without test development

# Установка JS зависимостей через npm (не через yarn)
RUN npm install --legacy-peer-deps

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
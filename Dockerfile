FROM ruby:2.7.4

# Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Установка нужной версии Bundler
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs)"

# Очистка конфигов и установка гемов
RUN bundle config unset deployment && \
    bundle config unset without && \
    bundle clean --force && \
    bundle config set --local deployment true && \
    bundle config set --local without 'test development' && \
    bundle config set --local jobs $(nproc) && \
    bundle install --without test development --retry 5 --verbose
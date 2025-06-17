# Используем базовый образ Ubuntu (можно другой подходящий)
FROM ruby:3.2

# Обновление и установка зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gnupg \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    && apt-get clean

# Установка Node.js 18 и Corepack
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && corepack enable \
    && corepack prepare yarn@stable --activate

# Установка рабочего каталога
WORKDIR /var/www

# Клонируем Discourse
RUN git clone https://github.com/discourse/discourse.git \
    && cd discourse \
    && git checkout main
    && sed -i '/"packageManager"/d' package.json

WORKDIR /var/www/discourse

# Установка зависимостей
RUN bundle config set --local path 'vendor/bundle' \
    && bundle install \
    && corepack enable \
    && yarn install --network-timeout 300000

# Открываем порт
EXPOSE 3000

# Запуск
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
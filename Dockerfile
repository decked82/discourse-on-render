FROM ruby:3.1-slim

# Устанавливаем только необходимые пакеты
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    git \
    curl \
    imagemagick \
    nodejs \
    npm \
    libvips-dev \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Клонируем стабильную версию
RUN git clone --depth 1 --branch stable https://github.com/discourse/discourse.git .

# Конфигурируем bundler для экономии памяти
ENV BUNDLE_JOBS=1
ENV BUNDLE_RETRY=5
ENV BUNDLE_BUILD__SASSC=--disable-march-tune-native
ENV MAKE="make -j1"

# Устанавливаем bundler
RUN gem install bundler:2.4.10

# Копируем Gemfile
COPY Gemfile* ./

# Установка с ограниченным параллелизмом для экономии памяти
RUN bundle config set --local deployment true && \
    bundle config set --local without 'test development' && \
    bundle config set --local jobs 1 && \
    bundle install --without test development --retry 5 --verbose

# Устанавливаем JS зависимости
RUN yarn install --frozen-lockfile --production

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
FROM ruby:3.1-bullseye

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    postgresql-client \
    imagemagick \
    git \
    curl \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Установка Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www/discourse

# Клонирование Discourse
RUN git clone https://github.com/discourse/discourse.git . \
    && git checkout latest-release

# Установка Ruby зависимостей
RUN gem install bundler:2.4.10
COPY Gemfile* ./
RUN bundle config set --local deployment true \
    && bundle config set --local without 'test development' \
    && bundle install --jobs 4 --retry 3

# Установка JavaScript зависимостей
RUN npm install -g yarn
RUN yarn install --frozen-lockfile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
# Используем официальный базовый образ Discourse
FROM discourse/base:2.0.20240116-0051

# Устанавливаем рабочую директорию
WORKDIR /var/www

# Клонируем исходники Discourse
RUN git clone https://github.com/discourse/discourse.git \
    && cd discourse \
    && git checkout main

# Устанавливаем зависимости
WORKDIR /var/www/discourse
RUN bundle config set --local path 'vendor/bundle' \
    && bundle install \
    && yarn install

# Клонируем плагины (опционально — можешь удалить, если не нужны)
RUN git clone https://github.com/discourse/discourse-voting.git plugins/discourse-voting

# Открываем нужные порты
EXPOSE 3000

# Указываем команду запуска
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

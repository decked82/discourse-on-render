# Используем официальный базовый образ Discourse
FROM discourse/base:release

# Устанавливаем рабочую директорию
WORKDIR /var/www/discourse

# Устанавливаем зависимости
RUN bundle config set --local path 'vendor/bundle' \
    && bundle install \
    && yarn install

# Клонируем плагин (опционально — можешь удалить или добавить свои)
RUN git clone https://github.com/discourse/discourse-voting.git plugins/discourse-voting

# Открываем порт
EXPOSE 3000

# Команда запуска
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
FROM discourse/discourse:release

# Установка зависимостей и переменных окружения
ENV RAILS_ENV=production

# Опционально: установка дополнительного софта (например, nano или curl)
 RUN apt-get update && apt-get install -y nano curl

# Копирование плагинов или конфигураций (если нужно)
 #COPY plugins /var/www/discourse/plugins

# Пример: добавим и активируем плагины
 #ENV DISCOURSE_PLUGINS="discourse-akismet discourse-sitemap"

# Запуск стандартной команды при старте контейнера
CMD ["bash", "-c", "RAILS_ENV=production bundle exec rake db:migrate && exec unicorn -c config/unicorn.conf.rb"]

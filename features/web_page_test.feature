# encoding: UTF-8
# language: ru

# Перед Вами пример работы тестов с UI

# Ваша задача: Написать сценарий, который бы открывал делал следующее:

# 1. Открывал https://www.ruby-lang.org/ru/
# 2. Переходил на вкладку https://www.ruby-lang.org/ru/downloads/
# 3. Скачивал оттуда последний стабильный релиз
# 4. Проверял, что файл находится в нужной директории
# 5. Проверял, что это имя скачанного файла совпадает с именем файла-установщика, указанного на сайте

  Функция: UI

    Сценарий: Работа с web-страницей

      Когда захожу на страницу "https://www.ruby-lang.org/ru/"
      И кликаю на вкладку с текстом "Скачать"
      И скачиваю из группы "Стабильные релизы" последний релиз в папку "\features\tmp" и запоминаю версию файла установщика

      Тогда жду не более "60" секунд пока загрузится файл в папку "\features\tmp"
      И проверяю, что версия в имени скачанного файла в "\features\tmp" совпадает с версией в имени файла-установщика, указанного на сайте
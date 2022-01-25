# frozen_string_literal: true

When(/^захожу на страницу "(.+?)"$/) do |url|
  visit url
  $logger.info("Страница #{url} открыта")
  sleep 1
end

When(/^ввожу в поисковой строке текст "([^"]*)"$/) do |text|
  query = find("//input[@name='q']")
  query.set(text)
  query.native.send_keys(:enter)
  $logger.info('Поисковый запрос отправлен')
  sleep 1
end

When(/^кликаю по строке выдачи с адресом (.+?)$/) do |url|
  link_first = find("//a[@href='#{url}/']/h3")
  link_first.click
  $logger.info("Переход на страницу #{url} осуществлен")
  sleep 1
end

When(/^я должен увидеть текст на странице "([^"]*)"$/) do |text_page|
  sleep 1
  expect(page).to have_text text_page
end

When(/^кликаю на вкладку с текстом "([^"]*)"$/) do |button_name|
  download_tab = find("//*[@id='header_content']/div[contains(@class, 'site-links')]/a[text()='#{button_name}']")
  download_tab.click
  $logger.info("Переход на вкладку с названием '#{button_name}' осуществлен")
  sleep 1
end

When(/^скачиваю из группы "([^"]*)" последний релиз в папку "([^"]*)" и запоминаю версию файла установщика$/) do |group_name, folder_name|
  last_release = find("//*[@id='content']/ul/li/strong[text()='#{group_name}:']/following-sibling::ul[1]/li[1]/a")
  last_release.click

  seconds = 0
  wait_sec = 30
  file_download_started = false
  $logger.info("Ожидание начала скачивания файла в течение #{wait_sec} секунд")

  while seconds <= wait_sec.to_i
    if directory_has_downloading_files(folder_name) == true
      $logger.info('Файл начал скачиваться')
      file_download_started = true
      break
    else
      print '.'
    end
    seconds += 1
    sleep 1
  end

  raise "Скачивание файла не началось в течение #{wait_sec} секунд" unless file_download_started

  @scenario_data.release_name = last_release.text
  $logger.info("Скачивание последнего релиза из группы #{group_name}")
  sleep 3
end

When(/^жду не более "([^"]*)" секунд пока загрузится файл в папку "([^"]*)"$/) do |wait_sec, folder_name|
  check_directory_exists(folder_name)

  $logger.info("Ожидание скачивания файла в течение #{wait_sec} секунд")

  seconds = 0
  file_downloaded = false

  while seconds <= wait_sec.to_i
    if directory_has_downloading_files(folder_name) == false
      $logger.info('Файл скачался')
      file_downloaded = true
      break
    else
      print '.'
    end
    seconds += 1
    sleep 1
  end

  raise "Файл не скачался за #{wait_sec} секунд" unless file_downloaded
end

When(/^проверяю, что версия в имени скачанного файла в "([^"]*)" совпадает с версией в имени файла-установщика, указанного на сайте$/) do |folder_name|
  release_version = @scenario_data.release_name.match(/^Ruby (.*$)/i).captures[0]

  expected_file_name = "ruby-#{release_version}.tar.gz"

  if check_file_exists(folder_name: folder_name, file_name: expected_file_name)
    $logger.info('Название файла совпадает с ожидаемым')
  else
    raise 'Название файла не совпадает с ожиданмым'
  end

  delete_all_files_in_directory(folder_name)
end
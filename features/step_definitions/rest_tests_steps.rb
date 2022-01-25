# frozen_string_literal: true

When(/^получаю информацию о пользователях$/) do
  users_full_information = $edisoft_api_client.users_list

  $logger.info('Информация о пользователях получена')
  @scenario_data.users_full_info = users_full_information
end

When(/^проверяю (наличие|отсутствие) логина (\w+\.\w+) в списке пользователей$/) do |presence, login|
  search_login_in_list = true
  presence == 'отсутствие' ? search_login_in_list = !search_login_in_list : search_login_in_list

  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)

  if login_presents
    message = "Логин #{login} присутствует в списке пользователей"
    search_login_in_list ? $logger.info(message) : raise(message)
  else
    message = "Логин #{login} отсутствует в списке пользователей"
    search_login_in_list ? raise(message) : $logger.info(message)
  end
end

When(/^добавляю пользователя с логином (\w+\.\w+) именем (\w+) фамилией (\w+) паролем ([\d\w@!#]+)$/) do
|login, name, surname, password|

  response = $edisoft_api_client.create_user(login: login,
                                             name: name,
                                             surname: surname,
                                             password: password,
                                             active: 1)
  $logger.info(response.inspect)
end

When(/^удаляю пользователя с логином (\w+\.\w+)$/) do |login|
  users_full_information = $edisoft_api_client.users_list

  user_id = find_user_id(users_information: users_full_information, user_login: login)

  response = $edisoft_api_client.delete_user(user_id)

  $logger.info(response.inspect)
end

When(/^добавляю пользователя с параметрами:$/) do |data_table|
  user_data = data_table.raw

  login = user_data[0][1]
  name = user_data[1][1]
  surname = user_data[2][1]
  password = user_data[3][1]

  step "добавляю пользователя с логином #{login} именем #{name} фамилией #{surname} паролем #{password}"
end

When(/^нахожу пользователя с логином (\w+\.\w+)$/) do |login|
  step %(получаю информацию о пользователях)
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                       .users_full_info,
                                                  user_login: login)
  end

  $logger.info("Найден пользователь #{login} с id:#{@scenario_data.users_id[login]}")
end

When(/^добавляю пользователя с логином (\w+\.\w+) и любыми именем, фамилией и паролем при его отсутствии$/) do
|login|
  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)
  unless login_presents
    $edisoft_api_client.create_user(login: login,
                                    name: 'andrew',
                                    surname: 'deny',
                                    password: 'Qwerty123@',
                                    active: 1)
  end
end

When(/^удаляю пользователя с логином (\w+\.\w+) при его наличии$/) do
|login|
  user_info = @scenario_data.users_full_info.select { |user| user['login'] == login }
  if user_info.size == 1
    $edisoft_api_client.delete_user(user_info[0]['id'])
  end
end

When(/^проверяю что у пользователя (\w+\.\w+) имя (\w+) фамалия (\w+)$/) do |login, name, surname|

  users_full_information = $edisoft_api_client.users_list
  user_info = users_full_information.select { |user| user['login'] == login }
  raise "Логин #{login} неуникален или не найден в списке" if user_info.size != 1

  if user_info[0]["name"] != name
    message = "У пользователя #{login} не сменилось имя на #{name}, текущее имя - #{user_info[0]["name"]}"
    raise(message)
  end

  if user_info[0]["surname"] != surname
    message = "У пользователя #{login} не сменилась фамилия на #{surname}, текущая фамилия - #{user_info[0]["surname"]}"
    raise(message)
  end

end

When(/^добавляю пользователя с логином (\w+\.\w+) именем (\w+) фамилией (\w+) паролем ([\d\w@!#]+) при его отсутствии$/) do
|login, name, surname, password|
  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)
  unless login_presents
    $edisoft_api_client.create_user(login: login,
                                    name: name,
                                    surname: surname,
                                    password: password,
                                    active: 1)
  end

end

When(/^изменяю имя, фамилию, пароль на (\w+), (\w+), ([\d\w@!#]+) у пользователя с логином (\w+\.\w+)$/) do
|name, surname, password, login|
  users_full_information = $edisoft_api_client.users_list

  user_id = find_user_id(users_information: users_full_information, user_login: login)

  response = $edisoft_api_client.update_user(id: user_id,
                                             login: login,
                                             name: name,
                                             surname: surname,
                                             password: password,
                                             active: 1)

  $logger.info(response.inspect)
  $logger.info("Изменён пользователь #{login} с id:#{user_id}")

end
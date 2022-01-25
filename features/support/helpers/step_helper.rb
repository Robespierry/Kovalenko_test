# frozen_string_literal: true

def find_user_id(users_information:, user_login:)

  user_info = users_information.select { |user| user['login'] == user_login }

  raise "Логин #{user_login} неуникален или не найден в списке" if user_info.size != 1

  user_info[0]['id']
end

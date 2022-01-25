# frozen_string_literal: true

class EdisoftApiClient
  attr_accessor :rest_wrap

  def initialize(url:, login:, password:)
    @rest_wrap = RestWrapper.new url: url, login: login, password: password
  end

  def users_list
    rest_wrap.get('/users')
  end

  def delete_user(id)
    rest_wrap.delete("/users/#{id}")
  end

  def create_user(login:, name:, surname:, password:, active:)
    rest_wrap.post('/users', login: login,
                   name: name,
                   surname: surname,
                   password: password,
                   active: active)

  end

  def update_user(id:, login:, name:, surname:, password:, active:)
    rest_wrap.put("/users/#{id}", login: login,
                  name: name,
                  surname: surname,
                  password: password,
                  active: active)
  end

end





class User < ApplicationRecord
  has_secure_password

  # Relationships
  has_many :carts

  # Knock - Find user while signing in
  def self.from_token_request(request)
    _username = request.params['auth'] && request.params['auth']['username']
    self.find_by_username _username
  end

  # Knock - Modify payload
  def to_token_payload
    {
        sub: id,
        username: username
    }
  end
end

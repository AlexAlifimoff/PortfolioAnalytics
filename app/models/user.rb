class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :login, presence: true
  validates :login, uniqueness: true
  validates :password, confirmation: true, presence: true
  validates :password_confirmation, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def password
    @password
  end

  def password=(password)
    @password = String.new(password)
    salt = SecureRandom.hex(20)
    salted_password = password.concat salt

    self.password_digest = Digest::SHA2.hexdigest(salted_password)
    self.salt = salt
    self.save
  end

  def password_valid?(password)
    salted_password = String.new(password + self.salt)
    password_digest = Digest::SHA2.hexdigest(salted_password)
    if password_digest == self.password_digest then
      return true
    else
      return false
    end
  end
end
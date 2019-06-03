class User < ActiveRecord::Base
	has_many :trips
	has_secure_password
end
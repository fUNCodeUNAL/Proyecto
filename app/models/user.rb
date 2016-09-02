class User < ApplicationRecord
	validates :email, uniqueness: true
	validates :email, :password, :full_name, absence: true
	validates :email, :password, confirmation: true
	validates :password, length: {minimum: 6}
end

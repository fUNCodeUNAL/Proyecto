class User < ApplicationRecord
  self.primary_key = "email"
  validates :email, uniqueness: { message: "is already taken"}, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :email, :password, :full_name, :email_confirmation, :password_confirmation, presence: { message: "is required" }
  validates :email, :password, confirmation: { case_sensitive: false }
  validates :password, length: { minimum: 6, message: "must be more than 6 characters long" }
end

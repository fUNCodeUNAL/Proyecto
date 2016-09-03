class User < ApplicationRecord
  self.primary_key = "email"
  validates :email, uniqueness: true, format: { with: /\A[a-zA-Z]+\z/, message: "Only allows letters" }
  validates :email, :password, :full_name, presence: true
  validates :email, confirmation: { case_sensitive: false }
  validates :email_confirmation, presence: true
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }
end

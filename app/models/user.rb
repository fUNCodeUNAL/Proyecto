class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  # Include for autentication only with unal emails
  # validates :email, format: { with: /\A[^@\s]+@(unal.edu.co)\z/ }
  validates :username, uniqueness: true, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows alphanumeric and underscore characters" }, length: {minimum: 5, maximum: 15, message: "length must be between 5 and 15 "}
  validates :full_name, presence: true
  has_many :submissions

  has_many :user_contest_relationships, dependent: :destroy
  has_many :contests, through: :user_contest_relationships
end

class Practitioner < ApplicationRecord
  has_many :communications, dependent: :destroy
  validates :first_name, :last_name, presence: true
end

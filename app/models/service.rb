class Service < ApplicationRecord
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
end

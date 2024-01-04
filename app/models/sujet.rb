class Sujet < ApplicationRecord
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true
  validates :numero, presence: true, uniqueness: true
  
end

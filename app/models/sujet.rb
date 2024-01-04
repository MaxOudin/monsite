class Sujet < ApplicationRecord
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  validates :numero, presence: true, uniqueness: true

end

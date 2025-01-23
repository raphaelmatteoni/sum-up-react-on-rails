class Group < ApplicationRecord
  belongs_to :bill
  has_many :items
end
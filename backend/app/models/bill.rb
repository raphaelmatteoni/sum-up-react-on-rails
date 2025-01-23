class Bill < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :groups, dependent: :destroy
end

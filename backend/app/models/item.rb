class Item < ApplicationRecord
  belongs_to :bill
  belongs_to :group, optional: true
end
class Bill < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :groups, dependent: :destroy

  def self.create_with_items(text)
    items_data = parse_items(text)
    
    Bill.transaction do
      bill = Bill.create!
      items_data.each do |item_data|
        bill.items.create!(item_data)
      end
      bill
    end
  end

  private

  def self.parse_items(text)
    text.split(/[;\n]/).map do |item_text|
      next if item_text.strip.empty?
      
      match = item_text.match(/([a-zA-Z]+)\s*([0-9.]+)/)
      next unless match

      {
        name: match[1],
        value: match[2].to_f
      }
    end.compact
  end
end
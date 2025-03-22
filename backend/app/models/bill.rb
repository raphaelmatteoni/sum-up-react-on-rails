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
    begin
      if text.strip.start_with?('{') && text.strip.end_with?('}')
        json_data = JSON.parse(text)
        
        if json_data["items"].is_a?(Array)
          expanded_items = []
          
          json_data["items"].each do |item|
            quantity = item["qty"] || 1
            quantity = quantity.to_i
            
            quantity.times do
              expanded_items << {
                name: item["name"],
                value: item["value"].to_f
              }
            end
          end
          
          return expanded_items
        end
      end
    rescue JSON::ParserError => e
      Rails.logger.warn("Não foi possível analisar como JSON: #{e.message}. Tentando método alternativo.")
    end    
  end
end
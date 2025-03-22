module Openai
  class ResponseHandler
    class << self
      def process_response(response)
        if response.success?
          parsed_response = JSON.parse(response.body)
          extracted_text = parsed_response.dig("choices", 0, "message", "content").to_s
          
          Rails.logger.info("Texto extraído: #{extracted_text}")
          
          return extracted_text
        else
          Rails.logger.error("Error API OpenAI: #{response.body}")
          raise "Error API OpenAI: #{response.code} - #{response.body}"
        end
      end
    end
  end
end 
module Openai
  class Config
    class << self
      def api_key
        ENV.fetch('OPENAI_API_KEY')
      end
      
      def base_url
        "https://api.openai.com/v1"
      end
      
      def chat_completions_url
        "#{base_url}/chat/completions"
      end
      
      def headers
        {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{api_key}"
        }
      end
    end
  end
end 
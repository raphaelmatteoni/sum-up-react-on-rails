require "base64"

class OpenaiService
  class << self
    def extract_text_from_image(image_data)
      Rails.logger.info("Enviando imagem para o OpenAI Vision API")
      
      base64_image = Base64.strict_encode64(image_data)
      payload = Openai::PayloadBuilder.build_image_analysis_payload(base64_image)
      
      response = HttpClient.post(
        Openai::Config.chat_completions_url,
        payload: payload,
        headers: Openai::Config.headers
      )
      
      Openai::ResponseHandler.process_response(response)
    rescue => e
      Rails.logger.error("Erro ao chamar API OpenAI: #{e.message}")
      raise e
    end
  end
end 
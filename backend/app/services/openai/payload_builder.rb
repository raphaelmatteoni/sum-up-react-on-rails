module Openai
  class PayloadBuilder
    class << self
      def build_image_analysis_payload(base64_image, prompt = nil)
        {
          model: "gpt-4o",
          messages: [
            {
              role: "system",
              content: Rails.configuration.ai_prompts.openai.dig(:image_analysis, :default_system_prompt)
            },
            {
              role: "user",
              content: [
                {
                  type: "image_url",
                  image_url: {
                    url: "data:image/jpeg;base64,#{base64_image}"
                  }
                },
                {
                  type: "text",
                  text: prompt || Rails.configuration.ai_prompts.openai.dig(:image_analysis, :default_user_prompt)
                }
              ]
            }
          ],
          response_format: {"type": "json_object"},
          max_tokens: 3000,
          temperature: 0.3
        }
      end
    end
  end
end 
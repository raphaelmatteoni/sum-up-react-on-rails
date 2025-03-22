class HttpClient
  def self.post(url, payload:, headers:, timeout: 60)
    HTTParty.post(
      url,
      body: payload.to_json,
      headers: headers,
      timeout: timeout
    )
  rescue => e
    Rails.logger.error("Erro na requisição HTTP: #{e.message}")
    raise e
  end
end
class BlololApiRequest
  # Delegates
  delegate :status, to: :response

  def initialize(path)
    @path = path
  end

  def body
    @body ||= JSON.parse(response.body)
  end

  def ok?
    status >= 200 && status < 400
  end

  def response
    @response ||= Excon.get(request_uri, headers: request_headers)
  end

  private

  def request_headers
    {
      'Accept' => 'application/json',
      'Authorization' => "key=#{Settings.blolol.api_key} secret=#{Settings.blolol.api_secret}",
      'Content-Type' => 'application/json'
    }
  end

  def request_uri
    'https://api.blolol.com/v1' + @path
  end
end

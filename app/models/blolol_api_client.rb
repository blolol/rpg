class BlololApiClient
  def initialize(path)
    @path = path
  end

  def self.chat_event(from:, to:, text:)
    body = { from: from, to: to, text: text, type: 'message' }
    new('/chat/events').post body
  end

  def get
    Response.new(Excon.get(uri, headers: headers)).raise_error_on_failure!
  end

  def post(body = nil)
    body = body ? JSON.generate(body) : nil
    Response.new(Excon.post(uri, body: body, headers: headers)).raise_error_on_failure!
  end

  def self.user(name)
    new("/users/#{URI.escape(name)}").get['user']
  end

  private

  def headers
    {
      'Accept' => 'application/json',
      'Authorization' => "key=#{Settings.blolol.api_key} secret=#{Settings.blolol.api_secret}",
      'Content-Type' => 'application/json'
    }
  end

  def uri
    'https://api.blolol.com/v1' + @path
  end

  class Response < SimpleDelegator
    # Delegates
    delegate :[], :dig, to: :parsed_body

    def ok?
      status.in? 200...400
    end

    def parsed_body
      @parsed_body ||= JSON.parse(body)
    end

    def raise_error_on_failure!
      if ok?
        self
      else
        raise "Blolol API returned #{status_line.strip} from #{path}. Body: #{body.inspect}"
      end
    end
  end
end

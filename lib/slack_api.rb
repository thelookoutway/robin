require "json"
require "net/http"
require "openssl"
require "uri"

module SlackAPI
  class Client
    def initialize(token:)
      @connection = HTTPConnection.new(token: token)
    end

    def chat_post_message(channel:, text:, attachments: [])
      HTTPResponse.new(@connection.post("/api/chat.postMessage", query: {channel: channel, text: text, attachments: JSON.dump(attachments)}))
    end

    def chat_update(ts:, channel:, text:, attachments: [])
      HTTPResponse.new(@connection.post("/api/chat.update", query: {ts: ts, channel: channel, text: text, attachments: JSON.dump(attachments)}))
    end
  end

  class HTTPConnection
    BASE_URI = URI.parse("https://slack.com")
    USER_AGENT = "robin (Ruby/#{RUBY_VERSION}-#{RUBY_PLATFORM})"

    def initialize(token:, base_uri: BASE_URI, user_agent: USER_AGENT)
      @base_uri = base_uri
      @token = token
      @user_agent = user_agent
      @http = Net::HTTP.new(base_uri.host, base_uri.port)
      @http.use_ssl = true
      @http.open_timeout = 10
      @http.read_timeout = 10
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    def post(path, query: {})
      request = Net::HTTP::Post.new(build_path(path, query: query))
      request["Content-Type"] = "application/x-www-form-urlencoded"
      perform_request(request)
    end

    private

    def build_path(path, query: {})
      path + "?" + URI.encode_www_form({token: @token}.merge(query))
    end

    def perform_request(request)
      request["Accept"] = 'application/json'
      request["User-Agent"] = @user_agent
      @http.request(request)
    end
  end

  class HTTPResponse
    def initialize(raw)
      @raw = raw
    end

    def code
      @raw.code
    end

    def body
      @raw.body
    end

    def data
      JSON.parse(@raw.body)
    end
  end
end

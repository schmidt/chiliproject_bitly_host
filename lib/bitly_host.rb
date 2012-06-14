module BitlyHost
  def username
    Setting.plugin_bitly_host["username"]
  end

  def api_key
    Setting.plugin_bitly_host["api_key"]
  end

  def client
    client = Bitly.new(username, api_key)

    if client.valid?(username, api_key)
      client
    else
      nil
    end
  end

  extend self
end

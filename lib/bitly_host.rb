module BitlyHost
  unloadable

  def username
    Setting.plugin_bitly_host["username"]
  end

  def api_key
    Setting.plugin_bitly_host["api_key"]
  end

  def client
    client = Bitly.new(username, api_key)

    # unfortunately the following method raises BitlyErrors - therefor we
    # need to guard this one with the rescue block below
    if client.valid?(username, api_key)
      client
    else
      nil
    end
  rescue BitlyError
    #TODO add logging
    nil
  end

  extend self
end

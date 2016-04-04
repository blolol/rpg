class BotAnnouncement
  def initialize(message, from: Settings.irc.nickname)
    @from = from
    @message = message
  end

  def announce
    each_irc_channel do |channel|
      BlololApiClient.chat_event from: @from, to: channel, text: @message
    end
  end

  private

  def each_irc_channel(&block)
    Settings.irc.channels.split(',').each &block
  end
end

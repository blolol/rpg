class BotHelpTopic
  def initialize(topic)
    @topic = topic
  end

  def to_s
    if documented?
      help
    else
      "Sorry! “#{@topic}” isn't a valid RPG command."
    end
  end

  private

  def documented?
    I18n.exists? key
  end

  def help
    I18n.t key
  end

  def key
    "irc.help.#{@topic}"
  end
end

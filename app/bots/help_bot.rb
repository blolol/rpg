class HelpBot
  include ApplicationBot

  # Matches
  match /help (\S+)/, method: :help

  def help(message, topic)
    key = "irc.help.#{topic}"

    if I18n.exists?(key)
      message.reply I18n.t(key)
    else
      message.reply "Sorry! “#{topic}” isn't a valid RPG command."
    end
  end
end

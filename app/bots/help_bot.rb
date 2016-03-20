class HelpBot
  include ApplicationBot

  # Commands
  command 'help' => :help, required: 1

  def help(message, topic)
    message.reply BotHelpTopic.new(topic).to_s
  end
end

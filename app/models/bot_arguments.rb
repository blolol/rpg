class BotArguments
  def initialize(bot, message)
    @bot = bot
    @message = message
  end

  def to_a
    parsed_arguments
  end

  private

  def command_and_unparsed_arguments
    @message.message.gsub prefix, ''
  end

  def harby_parser
    Harby::Parser.new { |name, arguments| name }
  end

  def parsed_arguments
    @parsed_arguments ||= if unparsed_arguments.present?
      harby_parser.parse unparsed_arguments
    else
      []
    end
  end

  def prefix
    @bot.class.prefix.call @message
  end

  def unparsed_arguments
    @unparsed_arguments ||= command_and_unparsed_arguments.gsub(/\A\S+\s*/, '')
  end
end

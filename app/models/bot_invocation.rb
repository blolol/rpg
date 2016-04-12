class BotInvocation
  def initialize(message)
    @message = message
  end

  def arguments
    @arguments ||= to_a[1..-1]
  end

  def command
    @command ||= to_a.first
  end

  def command?
    prefixed? && command.present?
  end

  def to_a
    @to_a ||= if message_without_prefix.present?
      harby_parser.parse message_without_prefix
    else
      []
    end
  end

  private

  def message_without_prefix
    @message_without_prefix ||= @message.message.gsub prefix, ''
  end

  def harby_parser
    Harby::Parser.new { |name, arguments| name }
  end

  def prefix
    ApplicationBot.__prefix__
  end

  def prefixed?
    @message.message =~ prefix
  end
end

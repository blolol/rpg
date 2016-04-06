module ApplicationBotHelper
  # Constants
  ZERO_WIDTH_NON_JOINER = "\u200c".freeze

  private

  def Silence(text_containing_nick)
    if text_containing_nick.length > 1
      text_containing_nick.dup.insert 1, ZERO_WIDTH_NON_JOINER
    else
      text_containing_nick
    end
  end
end

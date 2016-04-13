module ApplicationBotHelper
  # Constants
  ZERO_WIDTH_NON_JOINER = "\u200c".freeze

  private

  def character_not_found!(character_name)
    message.reply "There's no character named #{character_name} :(", prefix: true
    throw :halt
  end

  def find_character!(character_name)
    Character.find_by('name ILIKE ?', character_name) || character_not_found!(character_name)
  end

  def find_my_character!(character_name)
    current_user.find_character(character_name) || my_character_not_found!(character_name)
  end

  def my_character_not_found!(character_name)
    message.reply "You don't have a character named #{character_name} :(", prefix: true
    throw :halt
  end

  def Silence(text_containing_nick)
    if text_containing_nick.length > 1
      text_containing_nick.dup.insert 1, ZERO_WIDTH_NON_JOINER
    else
      text_containing_nick
    end
  end

  def Sterilize(string)
    Sanitize Unformat(string)
  end
end

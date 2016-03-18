class CharactersBot
  include ApplicationBot

  # Matches
  match /chars:list/, method: :list
  match /chars:create/, method: :create

  def create(message)
    character_name = arguments.first
    character_class = arguments.last

    character = Character.new(character_class: sterilize(character_class),
      name: sterilize(character_name), owner: message.user.user)

    if character.save
      message.reply "#{character} has entered the game!"
    else
      message.reply "Couldn't create your new character! #{character.errors.full_messages.first}.",
        prefix: true
    end
  end

  def list(message)
    characters = Character.where(owner: message.user.user)

    if characters.any?
      message.reply "You have #{pluralize characters.size, 'character'}: " +
        characters.map(&:to_s).join(', '), prefix: true
    else
      message.reply 'You have no characters :(', prefix: true
    end
  end
end

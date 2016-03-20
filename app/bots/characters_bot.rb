class CharactersBot
  include ApplicationBot

  # Commands
  command 'characters' => :list
  command 'characters:choose' => :choose, required: 1
  command 'characters:create' => :create, required: 2

  def choose(message, character_name)
    character = current_user.characters.find_by('name ILIKE ?', character_name)

    if character
      if character != current_user.current_character
        character.choose!
        message.reply "#{character} has entered the game!"
      else
        message.reply "You're already playing as #{character.name}!", prefix: true
      end
    else
      message.reply "You don't have a character named #{character_name} :(", prefix: true
    end
  end

  def create(message, character_name, character_class)
    character = current_user.characters.build(name: sterilize(character_name),
      role: sterilize(character_class))

    if character.save
      message.reply "#{character} has entered the game!"
    else
      message.reply "Couldn't create your new character! #{character.errors.full_messages.first}.",
        prefix: true
    end
  end

  def list(message)
    characters = current_user.characters.order(level: :desc, xp: :desc, name: :asc)

    if characters.any?
      message.reply "You have #{pluralize characters.size, 'character'}: " +
        characters.map(&:to_s).join(', '), prefix: true
    else
      message.reply 'You have no characters :(', prefix: true
    end
  end
end

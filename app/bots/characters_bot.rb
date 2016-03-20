class CharactersBot
  include ApplicationBot

  # Commands
  command 'characters' => :list
  command 'characters:choose' => :choose, required: 1
  command 'characters:create' => :create, required: 2
  command 'characters:delete' => :delete, required: 1
  command 'characters:rename' => :rename, required: 2

  def choose(message, character_name)
    character = find_character!(character_name)

    if character != current_user.current_character
      character.choose!
      message.reply "#{character} has entered the game!"
    else
      message.reply "You're already playing as #{character.name}!", prefix: true
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

  def delete(message, character_name)
    character = find_character!(character_name)
    character.destroy
    message.reply "#{character} has been deleted forever :(", prefix: true
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

  def rename(message, old_name, new_name)
    character = find_character!(old_name)

    old_name = character.name
    additional_xp_penalty = (character.xp_required_for_next_level * 0.1).round

    character.name = new_name
    character.xp_penalty += additional_xp_penalty

    if character.save
      message.reply "#{old_name} is now known as #{character}, and must earn an additional " \
        "#{additional_xp_penalty} XP to level up!"
    else
      message.reply "Couldn't rename #{old_name}! #{character.errors.full_messages.first}",
        prefix: true
    end
  end

  private

  def find_character!(character_name)
    character = current_user.find_character(character_name)

    if character
      character
    else
      message.reply "You don't have a character named #{character_name} :(", prefix: true
      throw :halt
    end
  end
end

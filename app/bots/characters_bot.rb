class CharactersBot
  include ApplicationBot

  # Matches
  match /characters:create (?<name>\w+) (?<class>\w+)/, method: :create

  def create(message, character_name, character_class)
    character = Character.new(character_class: sterilize(character_class),
      name: sterilize(character_name), owner: message.user.user)

    if character.save
      message.reply "#{character.name} the Level #{character.level} #{character.character_class} " \
        'has entered the game!'
    else
      message.reply "Couldn't create your new character! #{character.errors.full_messages.first}.",
        prefix: true
    end
  end
end

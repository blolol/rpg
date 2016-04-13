class CharactersBot
  include ApplicationBot

  # Commands
  %w(character characters char chars c).each do |group|
    command "#{group}" => :list
    command "#{group}:choose" => :choose, required: 1
    command "#{group}:create" => :create, required: 2
    command "#{group}:delete" => :delete, required: 1
    command "#{group}:info" => :info
    command "#{group}:online" => :online
    command "#{group}:reclass" => :reclass, required: 2
    command "#{group}:rename" => :rename, required: 2
  end

  def choose(message, character_name)
    character = find_my_character!(character_name)

    if character != current_user.current_character
      character.choose!
      message.reply "#{character} has entered the game!"
    else
      message.reply "You're already playing as #{character.name}!", prefix: true
    end
  end

  def create(message, character_name, character_class)
    character = current_user.characters.build(name: Sterilize(character_name),
      role: Sterilize(character_class))

    if character.save
      character.choose!
      message.reply "#{character} has entered the game!"
    else
      message.reply "Couldn't create your new character! #{character.errors.full_messages.first}.",
        prefix: true
    end
  end

  def delete(message, character_name)
    character = find_my_character!(character_name)
    character.destroy
    message.reply "#{character} has been deleted forever :(", prefix: true
  end

  def info(message, character_name = nil)
    character = character_name ? find_character!(character_name) : current_user.current_character

    if character
      character = CharacterInfoBotPresenter.new(character)

      message.reply character.name_and_level
      message.reply character.effect_names_and_descriptions
      message.reply character.penalty_description
      message.reply character.item_names_and_descriptions
      message.reply character.leveling_speed
    else
      message.reply 'You have no active character :(', prefix: true
    end
  end

  def list(message)
    characters = current_user.characters.order(level: :desc, xp: :desc, name: :asc)

    if characters.any?
      characters = CharactersListBotPresenter.new(message.user.nick, characters)

      message.reply characters.header

      characters.each do |character|
        message.reply character.index_and_description
      end
    else
      message.reply 'You have no characters :(', prefix: true
    end
  end

  def online(message)
    characters = Character.active.order(level: :desc, xp: :desc, name: :asc)

    if characters.any?
      characters = OnlineCharactersListBotPresenter.new(characters)

      message.reply characters.header

      characters.each do |character|
        message.reply character.index_and_description
      end
    else
      message.reply 'Nobody is currently playing :(', prefix: true
    end
  end

  def reclass(message, name, new_class)
    character = find_my_character!(name)

    old_class = character.role
    additional_xp_penalty = character.total_xp_required_for_next_level

    character.role = new_class
    character.xp_penalty += additional_xp_penalty

    if character.save
      message.reply "#{character.name} the Level #{character.level} #{old_class} has retrained " \
        "as a #{new_class}, and must earn an additional #{additional_xp_penalty} XP to reach " \
        "level #{character.level.next}!"
    else
      message.reply "Couldn't reclass #{character.name}! #{character.errors.full_messages.first}",
        prefix: true
    end
  end

  def rename(message, old_name, new_name)
    character = find_my_character!(old_name)

    old_name = character.name
    additional_xp_penalty = character.total_xp_required_for_next_level

    character.name = new_name
    character.xp_penalty += additional_xp_penalty

    if character.save
      message.reply "#{old_name} is now known as #{character}, and must earn an additional " \
        "#{additional_xp_penalty} XP to reach level #{character.level.next}!"
    else
      message.reply "Couldn't rename #{old_name}! #{character.errors.full_messages.first}",
        prefix: true
    end
  end
end

class AdminBot
  include ApplicationBot

  # Commands
  %w(admin a).each do |group|
    command "#{group}:battle" => :battle
    command "#{group}:penalize" => :penalize
    command "#{group}:xp" => :xp
  end

  def battle(message, challenger_name = nil, opponent_name = nil)
    authorize!

    challenger = challenger_name && find_character!(challenger_name)
    opponent = opponent_name && find_character!(opponent_name)
    BattleJob.perform_later challenger, opponent
  end

  def penalize(message, character_name, xp_penalty)
    authorize!

    xp_penalty = Integer(xp_penalty)

    if xp_penalty < 1
      message.reply 'You must penalize a positive amount of XP.', prefix: true
      throw :halt
    end

    character = find_character!(character_name)
    character.xp_penalty += xp_penalty

    if character.save
      message.reply "Penalized #{character.name} by #{xp_penalty} XP.", prefix: true
    else
      message.reply "Could not penalize #{character.name}: #{character.errors.full_messages.first}",
        prefix: true
    end
  end

  def xp(message, character_name, additional_xp)
    authorize!

    additional_xp = Integer(additional_xp)

    if additional_xp < 1
      message.reply 'You must grant a positive amount of XP.', prefix: true
      throw :halt
    end

    character = find_character!(character_name)
    character.add_xp additional_xp

    if character.save
      message.reply "Granted #{additional_xp} XP to #{character.name}.", prefix: true
    else
      message.reply "Could not grant XP to #{character.name}: " \
        "#{character.errors.full_messages.first}", prefix: true
    end
  end

  private

  def authorize!
    unless current_user.admin?
      throw :halt
    end
  end
end

class CharacterInfoBotPresenter < ApplicationBotPresenter
  def initialize(character)
    @character = character
  end

  def effect_names_and_descriptions
    names_and_descriptions = @character.effects.map do |effect|
      "#{effect.name} (#{effect.description})"
    end.join(', ')

    "Effects: #{names_and_descriptions}"
  end

  def name_and_level
    Format :bold, :underline, @character.to_s
  end

  def penalty_description
    if @character.penalized?
      substitutions = { next_level: @character.level.next, penalty: @character.xp_penalty }
      "Penalty: %{penalty} additional XP required to reach level %{next_level}" % substitutions
    end
  end
end

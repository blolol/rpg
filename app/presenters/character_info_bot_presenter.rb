class CharacterInfoBotPresenter < ApplicationBotPresenter
  def initialize(character)
    @character = character
  end

  def effect_names_and_descriptions
    if @character.effects.any?
      names_and_descriptions = @character.effects.map do |effect|
        EffectBotPresenter.new(effect).name_and_description
      end.join(', ')

      "Effects: #{names_and_descriptions}"
    else
      'No active effects'
    end
  end

  def gear_score
    "Gear Score: #{@character.gear_score}"
  end

  def item_names_and_descriptions
    if @character.items.any?
      names_and_descriptions = @character.items.order(level: :desc).map do |item|
        ItemBotPresenter.new(item).to_s
      end.join(', ')

      "Items: #{names_and_descriptions}"
    else
      'No items equipped'
    end
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

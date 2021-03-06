class CharacterInfoBotPresenter < ApplicationBotPresenter
  include ActionView::Helpers::DateHelper

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

  def leveling_speed
    leveling_speeds = [time_since_last_level, estimated_time_to_next_level].compact.join(', ')
    "Leveling: #{leveling_speeds}"
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
    substitutions = {
      premium: PremiumBotPresenter.new(@character).to_s,
      silenced_name_and_level: Format(:bold, :underline, Silence(@character.to_s)),
      silenced_owner: Silence(@character.user.blolol_user_data.username)
    }

    '%{silenced_name_and_level} played by %{silenced_owner}%{premium}' % substitutions
  end

  def penalty_description
    if @character.penalized?
      substitutions = { next_level: @character.level.next, penalty: @character.xp_penalty }
      "Penalty: %{penalty} additional XP required to reach level %{next_level}" % substitutions
    end
  end

  private

  def estimated_time_to_next_level
    if @character.xp_earned_per_tick.positive?
      next_level_at = Time.current + @character.estimated_seconds_to_next_level
      "#{time_ago_in_words(next_level_at)} until level #{@character.level.next}"
    else
      "but is not currently earning any XP, so it'll be a long time before " \
        "level #{@character.level.next}!"
    end
  end

  def time_since_last_level
    "#{time_ago_in_words(@character.last_level_at).capitalize} since last level"
  end
end

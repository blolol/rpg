class LevelUpBotPresenter < ApplicationBotPresenter
  include ActionView::Helpers::DateHelper

  # Constants
  DUMB_ONOMATOPOEIA = %w(Ding! Grats! Gratz!).freeze

  def initialize(character:, level:, total_xp_required_for_next_level:, last_level_at:)
    @character = character
    @level = level
    @total_xp_required_for_next_level = total_xp_required_for_next_level
    @last_level_at = Time.parse(last_level_at)
  end

  def message
    "#{dumb_onomatopoeia} After #{duration_since_last_level}, #{owner_possessive} " \
      "#{character_name_and_class} has reached #{new_level} Only " \
      "#{@total_xp_required_for_next_level} XP until level #{next_level}."
  end

  private

  def dumb_onomatopoeia
    DUMB_ONOMATOPOEIA.sample
  end

  def duration_since_last_level
    time_ago_in_words @last_level_at
  end

  def new_level
    Format :bold, "level #{@level}!"
  end

  def next_level
    @level.next
  end
end

class LevelUpAnnouncementPresenter < ApplicationBotPresenter
  include ActionView::Helpers::DateHelper

  # Constants
  DUMB_ONOMATOPOEIA = %w(Ding! Grats! Gratz!).freeze

  def initialize(character:, level:, xp_required_for_next_level:, last_level_at:)
    @character = character
    @level = level
    @xp_required_for_next_level = xp_required_for_next_level
    @last_level_at = Time.parse(last_level_at)
  end

  def message
    "#{dumb_onomatopoeia} After #{duration_since_last_level}, #{owner.username}'s character " \
      "#{character_name_and_class} has reached #{new_level} Only #{@xp_required_for_next_level} " \
      "XP until level #{next_level}."
  end

  private

  def character_name_and_class
    Format :bold, "#{@character.name} the #{@character.role}"
  end

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

  def owner
    @owner ||= @character.user.blolol_user_data
  end
end

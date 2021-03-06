class LevelUpAnnouncementJob < ApplicationJob
  include Cinch::Helpers

  queue_as :default

  def perform(character, level, total_xp_required_for_next_level, last_level_at)
    @character = character
    @level = level
    @total_xp_required_for_next_level = total_xp_required_for_next_level
    @last_level_at = last_level_at

    BotAnnouncement.new(message).announce
  end

  private

  def message
    LevelUpBotPresenter.new(character: @character, level: @level,
      total_xp_required_for_next_level: @total_xp_required_for_next_level,
      last_level_at: @last_level_at).message
  end
end

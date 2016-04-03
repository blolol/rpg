class LevelUpAnnouncementJob < ApplicationJob
  include Cinch::Helpers

  queue_as :default

  def perform(character, level, xp_required_for_next_level, last_level_at)
    @character = character
    @level = level
    @xp_required_for_next_level = xp_required_for_next_level
    @last_level_at = last_level_at

    ChatAnnouncement.new(message).announce
  end

  private

  def message
    LevelUpAnnouncementPresenter.new(character: @character, level: @level,
      xp_required_for_next_level: @xp_required_for_next_level,
      last_level_at: @last_level_at).message
  end
end

class LevelUpAnnouncementJob < ApplicationJob
  include Cinch::Helpers

  queue_as :default

  def perform(character, level, xp_required_for_next_level, last_level_at)
    @character = character
    @level = level
    @xp_required_for_next_level = xp_required_for_next_level
    @last_level_at = last_level_at

    each_irc_channel do |channel|
      BlololApiClient.chat_event from: Settings.irc.nickname, to: channel, text: message
    end
  end

  private

  def each_irc_channel(&block)
    Settings.irc.channels.split(',').each &block
  end

  def message
    @message ||= LevelUpAnnouncementPresenter.new(character: @character, level: @level,
      xp_required_for_next_level: @xp_required_for_next_level,
      last_level_at: @last_level_at).message
  end
end

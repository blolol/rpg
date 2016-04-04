class BattleJob < ApplicationJob
  queue_as :default

  def perform(challenger = nil, opponent = nil)
    battle = Battle.new(challenger: challenger, opponent: opponent)

    if battle.valid?
      battle.fight!

      message = BattleBotPresenter.new(battle).message
      BotAnnouncement.new(message).announce
    end
  end
end

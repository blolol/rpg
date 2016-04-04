class BattleReward
  def initialize(battle)
    @battle = battle
  end

  private

  # Delegates
  delegate :challenger, :challenger_won?, :difficulty, :fairness, :opponent, to: :@battle
end

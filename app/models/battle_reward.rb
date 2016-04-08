class BattleReward
  # Attributes
  attr_reader :description

  def initialize(battle)
    @battle = battle
  end

  private

  # Delegates
  delegate :challenger, :challenger_won?, :fairness, :loser, :opponent, :winner, to: :@battle
end

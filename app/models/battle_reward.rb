class BattleReward
  # Attributes
  attr_reader :description

  def initialize(battle)
    @battle = battle
  end

  private

  # Delegates
  delegate :challenger, :challenger_won?, :challenge_difficulty, :challenge_fairness, :loser,
    :opponent, :outcome_difficulty, :outcome_fairness, :winner, to: :@battle
end

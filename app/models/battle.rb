class Battle
  include ActiveModel::Validations

  # Attributes
  attr_reader :challenger, :challenger_roll, :loser, :opponent, :opponent_roll, :winner

  # Validations
  validates :challenger, active: true, presence: true
  validates :opponent, active: true, presence: true

  def initialize(challenger: nil, opponent: nil)
    @challenger = challenger || find_challenger
    @opponent = opponent || find_opponent
  end

  def challenger_won?
    challenger == winner
  end

  def difficulty
    @difficulty ||= level_difference + gear_score_difference
  end

  def fairness
    @fairness ||= if difficulty.abs <= 10
      :fair
    elsif difficulty.negative?
      :courageous
    else
      :cowardly
    end
  end

  def fight!
    if valid? && !fought?
      @challenger_roll = BattleRoll.new(challenger)
      @opponent_roll = BattleRoll.new(opponent)

      @loser, @winner = *[@challenger_roll, @opponent_roll].minmax.map(&:character)
      apply_rewards!
    end
  end

  def fought?
    !!winner
  end

  def rewards
    @rewards ||= BattleRewards.new(self).rewards
  end

  private

  def apply_rewards!
    rewards.each &:apply!
  end

  def find_challenger
    Character.active.order('RANDOM()').first
  end

  def find_opponent
    Character.active.where.not(id: challenger.id).order('RANDOM()').first
  end

  def gear_score_difference
    challenger.gear_score - opponent.gear_score
  end

  def level_difference
    challenger.level - opponent.level
  end
end

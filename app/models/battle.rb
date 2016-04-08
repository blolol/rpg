class Battle
  include ActiveModel::Validations

  # Attributes
  attr_reader :challenger, :challenger_roll, :loser, :opponent, :opponent_roll,
    :pre_battle_challenger, :pre_battle_opponent, :winner

  # Delegates
  delegate :balance, :fairness, to: :fairness_calculator

  # Validations
  validates :challenger, active: true, presence: true
  validates :opponent, active: true, presence: true

  def initialize(challenger: nil, opponent: nil)
    @challenger = challenger || find_challenger
    @opponent = opponent || find_opponent
    cache_pre_battle_character_state
  end

  def challenger_won?
    challenger == winner
  end

  def fight!
    if valid? && !fought?
      @challenger_roll = BattleRoll.new(challenger)
      @opponent_roll = BattleRoll.new(opponent)

      @loser, @winner = *[@challenger_roll, @opponent_roll].sort.map(&:character)
      apply_rewards!
    end
  end

  def fought?
    !!challenger_roll && !!opponent_roll
  end

  def rewards
    @rewards ||= BattleRewards.new(self).rewards
  end

  def tie?
    challenger_roll == opponent_roll
  end

  private

  def apply_rewards!
    rewards.each &:apply!
  end

  def cache_pre_battle_character_state
    @pre_battle_challenger = CachedCharacter.new(challenger)
    @pre_battle_opponent = CachedCharacter.new(opponent)
  end

  def fairness_calculator
    @fairness_calculator ||= BattleFairnessCalculator.new(challenger, opponent)
  end

  def find_challenger
    Character.active.order('RANDOM()').first
  end

  def find_opponent
    Character.active.where.not(id: challenger.id).order('RANDOM()').first
  end
end

class Battle
  include ActiveModel::Validations

  # Attributes
  attr_reader :challenger, :challenger_roll, :loser, :opponent, :opponent_roll,
    :pre_battle_challenger, :pre_battle_opponent, :winner

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

  def challenge_difficulty
    @challenge_difficulty ||= challenge_level_difference + challenge_gear_score_difference
  end

  def challenge_fairness
    @challenge_fairness ||= determine_fairness(challenge_difficulty)
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

  def outcome_difficulty
    @outcome_difficulty ||= outcome_level_difference + outcome_gear_score_difference
  end

  def outcome_fairness
    @outcome_fairness ||= determine_fairness(outcome_difficulty)
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

  def challenge_gear_score_difference
    challenger.gear_score - opponent.gear_score
  end

  def challenge_level_difference
    challenger.level - opponent.level
  end

  def determine_fairness(difficulty)
    if difficulty.abs <= 10
      :fair
    elsif difficulty.negative?
      :courageous
    else
      :cowardly
    end
  end

  def find_challenger
    Character.active.order('RANDOM()').first
  end

  def find_opponent
    Character.active.where.not(id: challenger.id).order('RANDOM()').first
  end

  def outcome_gear_score_difference
    winner.gear_score - loser.gear_score
  end

  def outcome_level_difference
    winner.level - loser.level
  end
end

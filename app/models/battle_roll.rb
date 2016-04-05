class BattleRoll
  include Comparable

  # Attributes
  attr_reader :character

  def initialize(character)
    @character = character
  end

  def score
    @score ||= rand(gear_score_with_minimum)
  end

  def <=>(other)
    score <=> other.score
  end

  private

  def gear_score_with_minimum
    [@character.gear_score, 1].max
  end
end

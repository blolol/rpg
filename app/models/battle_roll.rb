class BattleRoll
  include Comparable

  # Attributes
  attr_reader :character

  def initialize(character)
    @character = character
  end

  def score
    @score ||= rand(@character.gear_score)
  end

  def <=>(other)
    score <=> other.score
  end
end

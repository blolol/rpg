class BattleFairnessCalculator
  def initialize(challenger, opponent)
    @challenger = challenger
    @opponent = opponent
  end

  # The "balance" between two characters is their combined difference in level and gear score. The
  # challenger is on the "left" and their opponent is on the "right". If the balance is zero, it's
  # an even fight. If the balance is negative, the challenger is favored. If the balance is
  # positive, their opponent is favored.
  def balance
    @balance ||= level_difference + gear_score_difference
  end

  def fairness
    @fairness ||= if balance.abs <= 10
      :fair
    elsif balance.positive?
      :cowardly
    else
      :courageous
    end
  end

  private

  def gear_score_difference
    @challenger.gear_score - @opponent.gear_score
  end

  def level_difference
    @challenger.level - @opponent.level
  end
end

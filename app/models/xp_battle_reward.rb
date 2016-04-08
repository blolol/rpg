class XpBattleReward < BattleReward
  def actor
    challenger
  end

  def apply!
    if challenger_won?
      challenger.add_xp xp_reward
      @description = "was #{rewarded} #{xp_reward} XP for a #{fairness} fight"
    else
      challenger.xp_penalty += xp_penalty
      @description = "was #{penalized} #{xp_penalty} XP for a #{fairness} #{attempt_or_fight}"
    end

    challenger.save!
  end

  private

  def attempt_or_fight
    if !challenger_won? && fairness == :courageous
      'attempt'
    else
      'fight'
    end
  end

  def penalized
    if fairness == :courageous
      'only penalized'
    else
      'penalized'
    end
  end

  def rewarded
    if fairness == :cowardly
      'only rewarded'
    else
      'rewarded'
    end
  end

  def xp_penalty
    @xp_penalty ||= case fairness
      when :fair
        ((rand(8..40) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        ((rand(1..5) / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        ((rand(45..75) / 100.0) * challenger.xp_required_for_next_level).round
      end
  end

  def xp_reward
    @xp_reward ||= case fairness
      when :fair
        ((rand(8..40) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        ((rand(45..75) / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        ((rand(1..5) / 100.0) * challenger.xp_required_for_next_level).round
      end
  end
end

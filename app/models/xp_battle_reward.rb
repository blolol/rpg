class XpBattleReward < BattleReward
  def actor
    challenger
  end

  def apply!
    if challenger_won?
      challenger.add_xp xp_reward
    else
      challenger.xp_penalty += xp_penalty
    end

    challenger.save!
  end

  def description
    if challenger_won?
      "rewarded #{xp_reward} XP for a #{fairness} fight"
    else
      "penalized #{xp_penalty} XP for a #{fairness} fight"
    end
  end

  private

  def xp_penalty
    @xp_penalty ||= case fairness
      when :fair
        (((opponent.level / 7.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        (((difficulty.abs / 10.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        ((difficulty.abs / 100.0) * challenger.xp_required_for_next_level).round
      end
  end

  def xp_reward
    @xp_reward ||= case fairness
      when :fair
        (((opponent.level / 4.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        ((difficulty.abs / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        (((difficulty.abs / 10.0) / 100.0) * challenger.xp_required_for_next_level).round
      end
  end
end

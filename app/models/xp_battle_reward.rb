class XpBattleReward < BattleReward
  def actor
    challenger
  end

  def apply!
    if challenger_won?
      challenger.add_xp xp_reward
      @description = "was rewarded #{xp_reward} XP for a #{challenge_fairness} fight"
    else
      challenger.xp_penalty += xp_penalty
      @description = "was penalized #{xp_penalty} XP for a #{challenge_fairness} fight"
    end

    challenger.save!
  end

  private

  def xp_penalty
    @xp_penalty ||= case challenge_fairness
      when :fair
        (((opponent.level / 7.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        (((challenge_difficulty.abs / 10.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        ((challenge_difficulty.abs / 100.0) * challenger.xp_required_for_next_level).round
      end
  end

  def xp_reward
    @xp_reward ||= case challenge_fairness
      when :fair
        (((opponent.level / 4.0) / 100.0) * challenger.xp_required_for_next_level).round
      when :courageous
        ((challenge_difficulty.abs / 100.0) * challenger.xp_required_for_next_level).round
      when :cowardly
        (((challenge_difficulty.abs / 10.0) / 100.0) * challenger.xp_required_for_next_level).round
      end
  end
end

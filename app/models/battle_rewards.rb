class BattleRewards
  # Constants
  REWARD_TYPES = %w(ItemBattleReward XpBattleReward).freeze

  def initialize(battle)
    @battle = battle
  end

  def rewards
    @rewards ||= Array.new(count) { choose }
  end

  private

  def choose
    pool.pop.constantize.new @battle
  end

  def count
    rand 1..pool.size
  end

  def pool
    @pool ||= REWARD_TYPES.dup
  end
end

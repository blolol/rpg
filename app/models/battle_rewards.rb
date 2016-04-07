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

  # Delegates
  delegate :tie?, to: :@battle

  def choose
    pool.pop.constantize.new @battle
  end

  def count
    if tie?
      0
    else
      rand 1..pool.size
    end
  end

  def pool
    @pool ||= REWARD_TYPES.dup
  end
end

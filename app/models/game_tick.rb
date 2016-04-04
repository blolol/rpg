class GameTick
  def tick!
    enqueue_user_tick_jobs
    enqueue_find_item_job
    enqueue_battle_job
  end

  def self.tick!
    new.tick!
  end

  private

  def enqueue_battle_job
    if rand < Settings.game.battle_probability_per_tick
      BattleJob.perform_later
    end
  end

  def enqueue_find_item_job
    if rand < Settings.game.find_item_probability_per_tick
      FindItemJob.perform_later
    end
  end

  def enqueue_user_tick_jobs
    User.find_each do |user|
      UserTickJob.perform_later user
    end
  end
end

class CachedCharacter < SimpleDelegator
  # Attributes
  attr_reader :at

  def initialize(character)
    super character
    @character = character
    @at = Time.current.freeze
    cache_state
  end

  def gear_score
    @cached_gear_score
  end

  def level
    @cached_level
  end

  def to_s
    CharacterPresenter.new(self).description
  end

  def total_xp_required_for_next_level
    @cached_total_xp_required_for_next_level
  end

  def xp
    @cached_xp
  end

  private

  def cache_state
    @cached_gear_score = @character.gear_score
    @cached_level = @character.level
    @cached_total_xp_required_for_next_level = @character.total_xp_required_for_next_level
    @cached_xp = @character.xp
  end
end

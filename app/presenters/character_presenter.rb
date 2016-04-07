class CharacterPresenter
  def initialize(character)
    @character = character
  end

  def description
    "#{name} the Level #{level} #{role} (#{xp}/#{total_xp_required_for_next_level} XP, " \
      "#{gear_score} GS)"
  end

  private

  # Delegates
  delegate :gear_score, :level, :name, :role, :total_xp_required_for_next_level, :xp,
    to: :@character
end

class ApplicationBotPresenter
  include ApplicationBotHelper
  include Cinch::Helpers

  private

  def character_description(character = @character)
    Format :bold, character.to_s
  end

  def character_name_and_class(character = @character)
    Format :bold, "#{character.name} the #{character.role}"
  end

  def owner(character = @character)
    character.user
  end

  def owner_possessive(character = @character)
    "#{owner(character).blolol_user_data.username}'s character"
  end
end

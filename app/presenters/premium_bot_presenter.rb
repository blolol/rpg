class PremiumBotPresenter < ApplicationBotPresenter
  # Constants
  PLEBEIAN_LABEL = ''.freeze
  PREMIUM_LABEL = " \u269c".freeze

  def initialize(character)
    @character = character
  end

  def to_s
    if @character.user.premium?
      PREMIUM_LABEL
    else
      PLEBEIAN_LABEL
    end
  end
end

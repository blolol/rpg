class BattleBotPresenter < ApplicationBotPresenter
  # Constants
  TIE_DESCRIPTION = 'The two opponents, evenly-matched but exhausted, finally stumble apart and ' \
    'decide to settle their score another day. For now, to the pub!'.freeze

  def initialize(battle)
    @battle = battle
  end

  def message
    unless fought?
      raise 'Battle must already have been fought'
    end

    if tie?
      "#{battle_description} #{TIE_DESCRIPTION}"
    else
      "#{battle_description} #{rewards_description}"
    end
  end

  private

  # Delegates
  delegate :challenger, :challenger_roll, :challenger_won?, :fought?, :opponent, :opponent_roll,
    :rewards, :tie?, to: :@battle

  def battle_description
    "#{challenger_owner_possessive} #{challenger_description} challenged " \
      "#{opponent_owner_possessive} #{opponent_description} to battle and, with a roll of " \
      "#{challenger_roll.score} to #{opponent.name}'s #{opponent_roll.score}, " \
      "#{outcome_with_punctuation}"
  end

  def challenger_description
    character_description challenger
  end

  def challenger_owner_possessive
    owner_possessive challenger
  end

  def challenger_rewards_descriptions
    @challenger_rewards ||= rewards_grouped_by_actor[challenger]&.map(&:description)&.compact
  end

  def challenger_rewards_description_with_punctuation
    if challenger_rewards_descriptions&.any?
      list_of_rewards = challenger_rewards_descriptions.to_sentence
      "#{challenger.name} #{list_of_rewards}."
    end
  end

  def opponent_description
    character_description opponent
  end

  def opponent_owner_possessive
    owner_possessive opponent
  end

  def opponent_rewards_descriptions
    @opponent_rewards ||= rewards_grouped_by_actor[opponent]&.map(&:description)&.compact
  end

  def opponent_rewards_description_with_punctuation
    if opponent_rewards_descriptions&.any?
      list_of_rewards = opponent_rewards_descriptions.to_sentence
      "#{opponent.name} #{list_of_rewards}."
    end
  end

  def outcome_with_punctuation
    outcome = if tie?
      Format :orange, 'tied!'
    elsif challenger_won?
      Format :green, 'won!'
    else
      Format :red, 'lost!'
    end

    Format :bold, outcome
  end

  def rewards_description
    [challenger_rewards_description_with_punctuation,
      opponent_rewards_description_with_punctuation].compact.join ' '
  end

  def rewards_grouped_by_actor
    @rewards_grouped_by_actor ||= rewards.group_by(&:actor)
  end
end

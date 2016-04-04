class FoundItemBotPresenter < ApplicationBotPresenter
  def initialize(character, found_item, dropped_items, xp_reward)
    @character = character
    @found_item = found_item
    @dropped_items = dropped_items
    @xp_reward = xp_reward
  end

  def message
    message = "#{owner_possessive} #{character_description} found #{found_item_name_and_level}"

    if @dropped_items.any?
      message << ", dropped #{list_of_dropped_items},"
    end

    message << " and earned #{@xp_reward} XP!"
  end

  private

  def list_of_dropped_items
    @dropped_items.map { |item| ItemBotPresenter.new(item).to_s }.to_sentence
  end

  def found_item_name_and_level
    ItemBotPresenter.new(@found_item).to_s
  end
end

class FindNewItemPresenter < ApplicationBotPresenter
  def initialize(character, found_item, dropped_items)
    @character = character
    @found_item = found_item
    @dropped_items = dropped_items
  end

  def message
    message = "#{owner_possessive} #{character_description} found #{found_item_name_and_level}"

    if @dropped_items.any?
      message << " and dropped #{list_of_dropped_items}"
    end

    message << '!'
  end

  private

  def list_of_dropped_items
    @dropped_items.map { |item| ItemBotPresenter.new(item).to_s }.to_sentence
  end

  def found_item_name_and_level
    ItemBotPresenter.new(@found_item).to_s
  end
end

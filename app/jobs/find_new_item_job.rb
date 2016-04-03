class FindNewItemJob < ApplicationJob
  queue_as :default

  def perform(character)
    @character = character
    @found_item = Item.drop(@character)

    if found_item_is_an_upgrade?
      dropped_items = @character.equip(@found_item)

      if dropped_items
        message = FindNewItemPresenter.new(@character, @found_item, dropped_items).message
        ChatAnnouncement.new(message).announce
      end
    end
  end

  private

  def found_item_is_an_upgrade?
    @character.items.where('slot = ? AND level >= ?', @found_item.slot, @found_item.level).empty?
  end
end

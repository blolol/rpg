class FindItemJob < ApplicationJob
  queue_as :default

  def perform(character = nil)
    @character = character || find_character
    @found_item = Item.drop(@character)

    if found_item_is_an_upgrade?
      dropped_items = @character.equip(@found_item)

      if dropped_items
        message = FoundItemBotPresenter.new(@character, @found_item, dropped_items).message
        BotAnnouncement.new(message).announce
      end
    end
  end

  private

  def find_character
    Character.active.order('RANDOM()').first
  end

  def found_item_is_an_upgrade?
    @character.items.where('slot = ? AND level >= ?', @found_item.slot, @found_item.level).empty?
  end
end

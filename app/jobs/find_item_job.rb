class FindItemJob < ApplicationJob
  queue_as :default

  def perform(character = nil)
    @character = character || find_character

    if item_is_an_upgrade?
      dropped_items = @character.equip(item)

      if dropped_items
        @character.add_xp xp_reward
        @character.save!

        message = FoundItemBotPresenter.new(@character, item, dropped_items, xp_reward).message
        BotAnnouncement.new(message).announce
      end
    end
  end

  private

  def find_character
    Character.active.order('RANDOM()').first
  end

  def item_is_an_upgrade?
    @character.items.where('slot = ? AND level >= ?', item.slot, item.level).empty?
  end

  def item
    @item ||= Item.drop(@character)
  end

  def xp_reward
    @xp_reward ||= ((rand(5..12) / 100.0) * @character.total_xp_required_for_next_level).round
  end
end

class EffectBotPresenter < ApplicationBotPresenter
  # Delegates
  delegate :name, to: :@effect

  def initialize(effect)
    @effect = effect
  end

  def description
    @effect.description.tap do |description|
      if @effect.effectable_type == 'Item'
        item = ItemBotPresenter.new(@effect.effectable)
        description << ", granted by #{item.colored_name}"
      end
    end
  end

  def name_and_description
    "#{name} (#{description})"
  end
end

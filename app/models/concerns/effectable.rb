module Effectable
  extend ActiveSupport::Concern

  class_methods do
    def has_many_effects(prefix: nil)
      association_name = prefix ? :"#{prefix}_effects" : :effects

      has_many association_name, as: :effectable, class_name: 'Effect', dependent: :destroy do
        def add(effect)
          transaction do
            remove(effect.type) unless effect.stackable?
            self << effect
          end
        end

        def remove(type)
          where(type: type).destroy_all
        end
      end
    end
  end
end

class OnlineCharactersListBotPresenter < ApplicationBotPresenter
  include ActionView::Helpers::TextHelper

  def initialize(characters)
    @characters = characters
  end

  def each
    @characters.each_with_index do |character, index|
      yield OrderedListCharacterPresenter.new(character, index.next)
    end
  end

  def header
    character_count = pluralize(@characters.size, 'Character')
    Format :bold, :underline, "#{character_count} Online"
  end

  private

  class OrderedListCharacterPresenter < ApplicationBotPresenter
    def initialize(character, index)
      @character = character
      @index = index
    end

    def index_and_description
      "#{@index}. #{silenced_character} played by #{silenced_owner}#{premium}"
    end

    private

    def premium
      PremiumBotPresenter.new @character
    end

    def silenced_character
      Silence @character.to_s
    end

    def silenced_owner
      Silence @character.user.blolol_user_data.username
    end
  end
end

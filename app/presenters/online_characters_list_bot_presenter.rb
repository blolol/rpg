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

  class OrderedListCharacterPresenter
    def initialize(character, index)
      @character = character
      @index = index
    end

    def index_and_description
      "#{@index}. #{@character} played by #{owner}"
    end

    private

    def owner
      @character.user.blolol_user_data.username
    end
  end
end

class CharactersListBotPresenter < ApplicationBotPresenter
  def initialize(nick, characters)
    @nick = nick
    @characters = characters
  end

  def each
    @characters.each_with_index do |character, index|
      yield OrderedListCharacterPresenter.new(character, index.next)
    end
  end

  def header
    Format :bold, :underline, "#{@nick}'s Characters"
  end

  private

  class OrderedListCharacterPresenter < ApplicationBotPresenter
    def initialize(character, index)
      @character = character
      @index = index
    end

    def index_and_description
      if @character.current?
        bold_description = Format(:bold, "#{@index}. #{@character}")
        "#{bold_description} (current)"
      else
        "#{@index}. #{@character}"
      end
    end
  end
end

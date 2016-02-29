class CharactersBot
  include ApplicationBot

  # Matches
  match /characters:create (?<name>\w+) (?<class>\w+)/, method: :create

  def create(message, character_name, character_class)
    message.reply "user=#{message.user.user.inspect} name=#{character_name.inspect} class=#{character_class.inspect}"
  end
end

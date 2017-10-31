class Group
  attr_reader :players

  def initialize(players)
    @players = players
    @resolved = false
  end

  def add_strike_to_player(player_name)
    player = nil
    @players.each do |p|
      if p.name == player_name
        player = p
        p.add_strike
        @resolved = true
        break
      end
    end
    player
  end

  def player_names
    names = ""
    self.players.each_with_index do |p, i|
      names << p.name
      names << ', ' unless i == self.players.length - 1
    end
    names
  end

  def resolved?
    @resolved
  end
end

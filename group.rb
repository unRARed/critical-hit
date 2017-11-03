class Group
  attr_reader :players

  def initialize(players)
    @players = players
    @players_receiving_strike = []
  end

  def add_strike_to_player(player_name)
    player = nil
    @players.each do |p|
      if p.name == player_name &&
        !@players_receiving_strike.include?(p)
        player = p
        p.add_strike
        @players_receiving_strike << p
        break
      end
    end
    player
  end

  def state
   "[#{self.player_names}]"
  end

  def player_names
    names = ""
    self.players.each_with_index do |p, i|
      names << "(x) " if @players_receiving_strike.include?(p)
      names << p.name
      names << ', ' unless i == self.players.length - 1
    end
    names
  end

  def resolved?
    @players_receiving_strike.count >= (@players.count / 2).floor
  end
end

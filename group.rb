class Group
  @@instance_count = 0
  attr_reader :players,
              :id

  def initialize(players)
    @@instance_count += 1
    @id = @@instance_count
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

  def take_player(name)
    player = nil
    @players.each_with_index do |p, i|
      if p.name == name
        player = @players.slice!(i)
        break
      end
    end
    player
  end

  def give_player(player)
    @players << player
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

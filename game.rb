class Game
  IDEAL_GROUP_SIZE = 4
  CONDITIONAL_GROUP_SIZE = 3

  attr_reader :groups,
              :players,
              :byes,
              :round

  def initialize(players, options={})
    @options = {
      group_size: 4
    }.merge(options)

    @round = 0
    @groups = []
    @players = players
  end

  def byes
    @players.inject(0) {|sum, p| sum + p.byes }
  end

  def strikes_remaining
    @players.inject(0) {|sum, p| sum + p.strikes_remaining }
  end

  def state
    state = ''
    @groups.each_with_index do |g, i|
      state << "Group ID #{g.id}: #{g.state}" if !g.resolved?
      state << "\n" if i != @groups.count - 1
    end
    state
  end

  def get_players_group_id(player_name)
    group = nil
    @groups.each do |g|
      if g.players.any?{|p| p.name == player_name }
        group = g
        break
      end
    end
    group.id
  end

  def move_player(player_name, group_id)
    group = nil
    player = nil
    # ensure we have a real destination group
    @groups.each do|g|
      if g.id == group_id.to_i
        group = g
        break
      end
    end

    if group
      @groups.each do |g|
        player = g.take_player(player_name)
        break if player
      end
      group.give_player(player)
    else
      false
    end
  end

  def start_round
    # new groups each round
    @groups = []
    @round += 1

    # randomize (so first byes are not always the last signed up)
    # then sort players by their "byes" count
    #   those with most byes should be first to play...
    sorted_players = self.alive_players.shuffle.sort_by{ |p| -p.byes }

    # handle odd number of players
    players_to_sit = sorted_players.count % IDEAL_GROUP_SIZE
    if players_to_sit >= CONDITIONAL_GROUP_SIZE
      players_to_sit = players_to_sit - CONDITIONAL_GROUP_SIZE
    end

    if players_to_sit != 0 && alive_players.count > IDEAL_GROUP_SIZE
      puts ""
      puts "Players whom will sit this round: "
      puts ""
      # they get a "bye"
      sorted_players[-players_to_sit..-1].each{|p| puts p.name; p.add_bye }
      puts ""
      puts "---------------------------------"
      puts ""
      # and sit out this round
      sorted_players = sorted_players[0..-(players_to_sit+1)]
    end

    player_blocks = sorted_players.shuffle.each_slice(IDEAL_GROUP_SIZE)
    # remaining 1 or 2 players sit this one out
    # and receive a "bye"
    player_blocks.each do |player_block|
      @groups << Group.new(player_block)
    end
  end

  def add_strike_to_player(player_name)
    player = nil
    @groups.each do |g|
      if !g.resolved?
        player = g.add_strike_to_player(player_name)
        break if player
      end
    end
    player
  end

  def unresolved_groups?
    (@groups.count - @groups.select{|g| g.resolved? }.count) != 0
  end

  def alive_players
    @players.select{|p| p.alive? }
  end

  def alive_players_state
    state = ""
    self.alive_players.each_with_index do |p, i|
      state << "#{p.name} => #{p.strikes_remaining} Strikes Remaining, #{p.byes} Byes\n"
    end
    state
  end
end

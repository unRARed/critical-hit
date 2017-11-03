require "minitest/autorun"
require './game.rb'
require './player.rb'
require './group.rb'
require "byebug"

class TestCriticalHit < Minitest::Test
  def setup
    # 15 so we can test both group sizes
    @player_names = [
      'Ryan',
      'Josiah',
      'Terence',
      'Elliot',
      'Nate',
      'Steve',
      'Mark',
      'Jim',
      'Mario',
      'Earl',
      'James',
      'Ned',
      'Frank',
      'Josh',
      'Tanya'
    ]
  end

  def test_start_round
    @game = Game.new @player_names.map{|pn| Player.new pn }
    @game.start_round

    assert_equal 1, @game.round
    assert_equal 15, @game.players.count
    # 3 groups of 4 and 1 group of 3
    assert_equal 4, @game.groups.count
  end

  def test_bye
    # only 14 players
    @game = Game.new @player_names[0..-2].map{|pn| Player.new pn }
    @game.start_round

    assert_equal 1, @game.round
    assert_equal 14, @game.players.count
    # 3 groups of 4
    assert_equal 3, @game.groups.count
    # 2 players on BYE
    assert_equal 2, @game.byes
  end

  def test_lots_of_players
    skip
  end

  def test_moving_player
    @game = Game.new @player_names.map{|pn| Player.new pn }
    @game.start_round
    player = @game.groups.first.players.first
    @game.move_player player.name, @game.groups.first.id
    assert_equal @game.groups.first.id,
                 @game.get_players_group_id(player.name)
  end

  def test_strikes
    @game = Game.new @player_names.map{|pn| Player.new pn }
    @game.start_round
    starting_strikes = @game.players.count * 3
    assert_equal @game.strikes_remaining, starting_strikes
    @game.add_strike_to_player('Ryan')
    @game.start_round
    assert_equal @game.strikes_remaining, starting_strikes - 1
    2.times { @game.add_strike_to_player('Ryan') }
    assert_equal @game.strikes_remaining, starting_strikes - 2
  end
end

require './game.rb'
require './player.rb'
require './group.rb'
#require 'byebug'

players = []
groups = []

puts "\n             You are about to experience a..."
puts ""
puts %(  .,-::::: :::::::..   ::::::::::::::::::  .,-:::::   :::.      :::
,;;;'````' ;;;;``;;;;  ;;;;;;;;;;;'''';;;,;;;'````'   ;;`;;     ;;;
[[[         [[[,/[[['  [[[     [[     [[[[[[         ,[[ '[[,   [[[
$$$         $$$$$$c    $$$     $$     $$$$$$        c$$$cc$$$c  $$'
`88bo,__,o, 888b "88bo,888     88,    888`88bo,__,o, 888   888,o88oo,.__
  "YUMMMMMP"MMMM   "W" MMM     MMM    MMM  "YUMMMMMP"YMM   ""` """"YUMMM
                  ::   .:  :::::::::::::::
                 ,;;   ;;, ;;;;;;;;;;;''''
                ,[[[,,,[[[ [[[     [[
                "$$$"""$$$ $$$     $$
                 888   "88o888     88,
                 MMM    YMMMMM     MMM
)
puts "\n          Critical Hit Pinball Tournament Manager.\n"
puts ""
begin
  print 'Number of players: '
  num_players = Integer(gets.chomp)
rescue Exception => e
  print '(Please enter a whole number) '
  retry
end

(1..num_players).each do |player_index|
  print "Please enter Player #{player_index}'s name: "
  players << Player.new(gets.chomp)
end

game = Game.new players

while game.alive_players.count > 1
  game.start_round
  puts "Round #{game.round}"
  puts ""

  # Prompt for group manipulation
  loop do
    puts game.state
    puts ""
    print 'Anyone need to move from their group? (y/n): '
    groups_are_good = gets.chomp.downcase != 'y'
    puts ""
    break if groups_are_good
    print 'Type the name of the player to move: '
    moving_player_name = gets.chomp
    print 'Which group is this player moving to? (1, 2, 3, etc.): '
    destination_group_id = gets.chomp
    unless game.move_player(moving_player_name,
                       destination_group_id)
      puts ""
      puts 'Either the player or the group was not found. Please try again.'
      puts ""
    end
  end

  # Prompt for player getting a strike
  while game.unresolved_groups?
    puts game.state
    puts ""
    print 'Who gets a strike: '
    player = game.add_strike_to_player(gets.chomp)
    puts ""
    if player && !player.alive?
      puts ""
      puts "     >>>>>>>>> #{player.name} has been eliminated. <<<<<<<<<"
      puts ""
    end
  end
  puts ""
  puts "---------------------------------"
  puts ""
  puts "Players still alive:"
  puts "____________________________________"
  puts game.alive_players_state
  puts ""
  puts "---------------------------------"
end

puts ""
puts "     >>>>>>>>> #{game.alive_players.first.name} wins the Tournament! <<<<<<<<<"
puts ""

exit 1

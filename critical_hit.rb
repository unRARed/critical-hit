require './game.rb'
require './player.rb'
require './group.rb'
#require 'byebug'

GROUP_SIZE = 3

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

  # Prompt for player getting a strike
  while game.unresolved_groups?
    puts game.state
    puts ""
    print 'Who gets a strike: '
    player = game.add_strike_to_player(gets.chomp)
    if player && !player.alive?
      puts ""
      puts "     >>>>>>>>> #{player.name} has been eliminated. <<<<<<<<<"
      puts ""
    end
  end
  puts "Players still alive:"
  puts game.alive_players_state
  puts ""
  puts "---------------------------------"
end

puts ""
puts "#{game.alive_players.first.name} wins the Critical Hit Tournament!"
puts ""

exit 1

# frozen_string_literal: true

require_relative 'game'
require_relative 'player'
require_relative 'human'
require_relative 'computer'
require_relative 'display'
require_relative 'array'

comp = Computer.new
player = Human.new
mastermind = Game.new(player, comp)

system('clear')
mastermind.display_welcome_message
loop do
  system('clear')
  mastermind.play_game
  break unless mastermind.play_again?
end
mastermind.display_goodbye

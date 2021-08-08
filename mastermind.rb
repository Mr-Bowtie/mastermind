# frozen_string_literal: true

require 'rainbow'
require 'pry'

# Contains methods for displaying game results and messages
module Display
  COLORS = { 'r' => Rainbow('  ').bg(:red),
             'p' => Rainbow('  ').bg(:purple),
             'o' => Rainbow('  ').bg(:orange),
             'b' => Rainbow('  ').bg(:blue),
             'm' => Rainbow('  ').bg(:magenta),
             'g' => Rainbow('  ').bg(:green) }.freeze

  def prompt(input)
    puts "==:| #{input}"
  end

  def display_welcome_message
    prompt "Welcome to Mastermind!\n\n"
    prompt "In this game one player creates a secret code madeup of#{Rainbow(' 4 ').bg(:red)}colors from this list:"
    prompt 'red, purple, orange, blue, magenta, and green'
    display_code(COLORS.keys)
    prompt "Then, the other player tries to guess that code before#{Rainbow(' 10 ').bg(:red)}rounds are up."
    prompt 'After each guess, the code breaker will get hints in the form of keypins.'
    prompt "A red pin -#{Rainbow('@').red}- for every guess that is the correct color in the correct position."
    prompt "A white pin -#{Rainbow('@').white}- for every guess that is a correct color, but in the wrong position."
    prompt "Good luck!\n\n"
    prompt 'press Enter to start the game'
    gets.chomp
  end

  def display_replay_message
    prompt 'Would you like to play again? ( yes | no )'
  end

  def display_result(winner, maker_code)
    case winner
    when breaker
      prompt "The #{winner.name} has cracked the code!"
    when maker
      prompt "The #{winner.name}s code remains unbroken."
    end
    prompt 'The secret code was:'
    display_code(maker_code)
  end

  def display_goodbye
    prompt 'Thanks for playing!'
  end

  def display_code(code)
    print '==:| '
    code.each { |e| print COLORS[e] }
    puts ''
  end

  def display_keypins(keypins)
    colored_pins = keypins.map do |key|
      case key
      when 'white'
        Rainbow('@').white
      when 'red'
        Rainbow('@').red
      end
    end
    puts "|: #{colored_pins.join(' ')} :|\n\n"
  end

  def display_roles_message
    prompt 'Would you like to be the code-maker or code-breaker? (enter maker or breaker)' # ! Display
  end

  def display_code_input_message
    prompt 'Input code: Valid options (r, p, o, b, m, g) '
  end
end

class Player
  include Display
  attr_accessor :code, :role, :winner

  @@color_options = ['g', 'm', 'p', 'b', 'o', 'r']

  def initialize
    @role = ''
    @code = []
    @winner = false
  end

  def valid_input?(array)
    array.each do |char|
      unless @@color_options.include?(char) && array.size == 4
        puts 'invalid input' # !display
        return false
      end
    end
    true
  end
end

class Human < Player
  include Display
  attr_reader :name

  def initialize
    super
    @name = 'Player'
  end

  def make_code
    display_code_input_message
    self.code = gets.chomp.chars
  end
end

class Computer < Player
  include Display
  attr_reader :name

  def initialize
    super
    @name = 'Computer'
  end

  def make_code
    4.times do |i|
      self.code[i] = @@color_options.sample
    end
  end
end

class Game
  include Display
  attr_accessor :human, :computer, :keypins, :maker, :breaker

  def initialize(human, computer)
    @human = human
    @computer = computer
    @keypins = []
    @maker = ''
    @breaker = ''
  end

  def set_roles
    loop do
      display_roles_message
      choice = gets.chomp.downcase
      if valid_role?(choice)
        case choice
        when 'maker'
          self.maker = human
          self.breaker = computer
        when 'breaker'
          self.maker = computer
          self.breaker = human
        end
        break
      end
    end
  end

  def valid_role?(input)
    if %w[maker breaker].include?(input)
      return true
    else
      puts 'Invalid input : please enter maker or breaker' # ! display
    end
  end

  def get_code(player)
    loop do
      player.make_code
      break if player.valid_input?(player.code)
    end
  end

  def breaker_round
    get_code(breaker)
    display_code(breaker.code)
    generate_keypins(maker.code, breaker.code)
    display_keypins(keypins)
  end

  #returns array, the player at index 0 is the maker, index 1 is the breaker

  def breaker_win?
    keypins == %w[red red red red]
  end

  def play_game
    set_roles
    get_code(self.maker)
    10.times do
      breaker_round
      break if breaker_win?
    end
    display_result(determine_winner, maker.code)
  end

  def determine_winner
    breaker_win? ? breaker : maker
  end

  def play_again?
    display_replay_message
    loop do
      choice = gets.chomp
      return true if %w[yes y].include?(choice)
      return false if %w[no n].include?(choice)

      prompt 'Invalid input - valid choices (yes, y, no, n) '
    end
  end

  def generate_keypins(code, guess)
    self.keypins = []
    redpins = get_red_pins(code, guess)
    guess = remove_correct_guesses(guess, redpins)
    code = remove_correct_guesses(code, redpins)

    # compares the two arrays and returns a new array that contains only elements that both contain
    # a white keypin is added for each element in this new array.
    whitepins = code.intersection(guess)
    redpins.size.times { keypins << 'red' }
    whitepins.size.times { keypins << 'white' }
  end

  # * returns an array of all the indexes at which the guess perfectly matched the secret code
  def get_red_pins(code, guess)
    indices = []
    4.times do |i|
      indices << i if guess[i] == code[i]
    end
    indices
  end

  # * returns a new array of the elements whose index is not in the redpins array
  def remove_correct_guesses(code, redpins)
    code.reject { |el| redpins.include?(code.index(el)) }
  end
end

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

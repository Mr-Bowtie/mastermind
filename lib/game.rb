require_relative 'display'
require_relative 'array'

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
      next unless valid_role?(choice)

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

  def valid_role?(input)
    if %w[maker breaker].include?(input)
      true
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

  # returns array, the player at index 0 is the maker, index 1 is the breaker

  def breaker_win?
    keypins == %w[red red red red]
  end

  def play_game
    set_roles
    get_code(maker)
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
    # resets keypins
    self.keypins = []
    redpins = get_red_pin_indices(code, guess)
    remove_correct_guesses(code, guess, redpins)
    #TODO extract whitepins
    whitepins = guess.select { |el| code.include?(el) }.uniq
    redpins.size.times { keypins << 'red' }
    whitepins.size.times { keypins << 'white' }
  end

  # * returns an array of all the indices at which the guess perfectly matched the secret code
  def get_red_pin_indices(code, guess)
    indices = []
    4.times do |i|
      indices << i if guess[i] == code[i]
    end
    indices
  end

  # * returns a new array of the elements whose index is not in the redpins array
  def remove_correct_guesses(code, guess, redpins)
    remove_redpins = lambda { |input| input.reject! { |el| redpins.include?(input.index(el)) } }
    remove_redpins.call(code)
    remove_redpins.call(guess)
  end
end

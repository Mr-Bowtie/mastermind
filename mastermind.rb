require "pry"

module Display
end

class Player
  attr_accessor :code, :role

  @@color_options = ["g", "m", "c", "b", "o", "r"]

  def initialize
    @role = ""
    @code = []
  end

  def valid_input?(array)
    if array.size != 4
      return false
    end
    array.each do |char|
      unless @@color_options.include?(char)
        puts "invalid input" #!display
        return false
      end
    end
    true
  end
end

class Human < Player
  def make_code
    case self.role
    when "maker"
      puts "input code"
      self.code = gets.chomp.chars
    when "breaker"
      puts "input guess"
      self.code = gets.chomp.chars
    end
  end
end

class Computer < Player
  def make_code
    # 4.times do |i|
    #   self.code[i] = @@color_options.sample
    # end
    self.code = %w(r g o m) #! for testing purposes
  end
end

class Game
  attr_accessor :human, :computer, :keypins

  def initialize(human, computer)
    @human = human
    @computer = computer
    @keypins = []
  end

  def set_roles
    loop do
      puts "Would you like to be the code-maker or code-breaker? (enter maker or breaker)" #! Display
      choice = gets.chomp.downcase
      if valid_role?(choice)
        case choice
        when "maker"
          self.human.role = "maker"
          self.computer.role = "breaker"
        when "breaker"
          self.human.role = "breaker"
          self.computer.role = "maker"
        end
        break
      end
    end
  end

  def valid_role?(input)
    if input == "maker" || input == "breaker"
      return true
    else
      puts "Invalid input : please enter maker or breaker" #! display
    end
  end

  def play_game
    set_roles()
    maker = (human.role == "maker") ? self.human : self.computer #todo make set_roles return a two item array, set maker and breaker withit at once
    breaker = (human.role == "breaker") ? self.human : self.computer
    maker.make_code
    until self.keypins == %w(red red red red)
      loop do
        breaker.make_code
        if breaker.valid_input?(breaker.code)
          break
        end
      end
      generate_keypins(maker.code, breaker.code)
      next
    end
  end

  def generate_keypins(code, guess)
    self.keypins = []
    redpins = get_red_pins(code, guess)

    guess = remove_correct_guesses(guess, redpins)
    code = remove_correct_guesses(code, redpins)

    #compares the two arrays and returns a new array that contains only elements that both contain
    #a white keypin is added for each element in this new array.
    whitepins = code.intersection(guess)
    redpins.size.times { self.keypins << "red" }
    whitepins.size.times { self.keypins << "white" }
  end

  #* returns an array of all the indexes at which the guess perfectly matched the secret code
  def get_red_pins(code, guess)
    indices = []
    4.times do |i|
      if guess[i] == code[i]
        indices << i
      end
    end
    indices
  end

  #* returns a new array of the elements whose index is not in the redpins array
  def remove_correct_guesses(code, redpins)
    code.reject { |el| redpins.include?(code.index(el)) }
  end
end

comp = Computer.new
player = Human.new
mastermind = Game.new(player, comp)

mastermind.play_game

require "pry"

module Display
end

class Player
  attr_accessor :code

  @@color_options = ["g", "m", "c", "b", "o", "r"]

  def initialize
    @role = ""
    @code = []
    @correct_colors = {}
    @misplaced_colors = {}
  end

  def eval_guess(guess)
    hints = []
    matched_color_indices = []
    code_copy = self.code.clone

    #todo break out into seperate methods
    # Checks for colors in the same position in the guess and code match
    # if they do, the red keypin is added to the hints array & the index is stored in matched_color_indicies
    4.times do |i|
      if guess[i] == self.code[i]
        hints << "red"
        matched_color_indices << i
      end
    end

    #creates new arrays with the matched colors removed
    guess = guess.reject { |el| matched_color_indices.include?(guess.index(el)) }
    code_copy = code_copy.reject { |el| matched_color_indices.include?(code_copy.index(el)) }

    #compares the two arrays and returns a new array that contains only elements that both contain
    #a white keypin is added for each element in this new array.
    whites = code_copy.intersection(guess)
    whites.size.times { hints << "white" }
    hints
  end
end

class Human < Player
  def get_guess
    puts "input guess"
    gets.chomp.chars
  end

  def valid_input?(array)
    if array.size != 4 
      return false 
    end 
    array.each do |char| 
      unless @@color_options.include?(char)
        return false
      end 
    end 
    true
  end 

class Computer < Player
  def make_code
    # 4.times do |i|
    #   self.code[i] = @@color_options.sample
    # end
    self.code = %w(r g o m)
  end
end

class Game
end

comp = Computer.new
comp.make_code
player = Human.new
loop do
  loop do
  choice = player.get_guess
  break if valid_input?(choice)
  end 
  hints = comp.eval_guess(choice)
  p hints
  break if hints == ["red", "red", "red", "red"]; end
end

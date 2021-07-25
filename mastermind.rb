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

    4.times do |i|
      if guess[i] == self.code[i]
        hints << "red"
        self.correct_colors[i] = guess[i]
      end
    end

    4.times do |i|
      
    end 
    whites = code_copy.intersection(leftovers)
    whites.size.times { hints << "white" }
    hints
  end
end

class Human < Player
  def get_guess
    puts "input guess"
    gets.chomp.chars
  end
end

class Computer < Player
  def make_code
    # 4.times do |i|
    #   self.code[i] = @@color_options.sample
    # end
    self.code = 
  end
end

class Game
end

comp = Computer.new
comp.make_code
player = Human.new
loop do
  hints = comp.eval_guess(player.get_guess)
  p hints
  break if hints == ["red", "red", "red", "red"]
end
p comp.code

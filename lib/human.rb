class Human < Player
  include Display
  attr_reader :name

  def initialize
    super
    @name = 'Player'
  end

  def make_code
    display_code_input_message
    self.code = gets.chomp.downcase.gsub(/\s+/, '').chars
  end
end

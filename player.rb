class Player
  include Display
  attr_accessor :code, :role, :winner

  @@color_options = %w[g m p b o r]

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

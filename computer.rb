class Computer < Player
  include Display
  attr_reader :name

  def initialize
    super
    @name = 'Computer'
  end

  def make_code
    4.times do |i|
      code[i] = @@color_options.sample
    end
  end
end

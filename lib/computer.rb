class Computer < Player
  include Display
  attr_reader :name
  attr_accessor :positions_to_update

  def initialize
    super
    @name = 'Computer'
    @positions_to_update = []
  end

  def make_code(redpins: [], whitepins: [])
    self.positions_to_update = [0, 1, 2, 3]
    if code.empty?
      4.times do |i|
        code[i] = @@color_options.sample
      end
    end
    retain_redpins(redpins) if redpins.size > 0
    remix_whitepins(whitepins) if whitepins.size > 0

    positions_to_update.each do |i|
      code[i] = @@color_options.sample
    end
  end
end

def retain_redpins(redpins)
  positions_to_update.reject! { |i| redpins.include?(i) }
end

def remix_whitepins(whitepins)
  whitepins.each do |w|
    position = positions_to_update.sample
    positions_to_update.delete(position)
    code[position] = w
  end
end

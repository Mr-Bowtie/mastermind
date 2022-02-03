require_relative('../lib/display.rb')
require_relative('../lib/player.rb')
require_relative('../lib/computer.rb')

describe Computer do
  describe '#make_code' do
    let(:test_computer) { described_class.new }
    before(:example) do
      test_computer.code = []
    end
    context 'When code array is empty' do
      it 'creates a new guess with 4 elements' do
        test_computer.make_code
        expect(test_computer.code.length).to eql(4)
      end
    end

    context 'When guess returns redpins' do
      it 'guess array retains redpin guesses' do
        test_redpins = [0, 3]
        test_code = %w[r p o m]
        test_computer.code = test_code
        test_computer.make_code(redpins: test_redpins)
        comp_redpin_locations = []
        test_computer.code.each_with_index { |guess, index| comp_redpin_locations << guess if test_redpins.include?(index) }
        test_redpin_locations = []
        test_code.each_with_index { |guess, index| test_redpin_locations << guess if test_redpins.include?(index) }
        expect(comp_redpin_locations).to eql(test_redpin_locations)
      end
    end

    context 'When guess returns whitepins' do
      it 'uses those whitepin elements in the new guess' do
        test_whitepins = %w[p g]
        test_code = %w[r p g m]
        test_computer.code = test_code
        test_computer.make_code(whitepins: test_whitepins)
        expect(test_computer.code.intersection(test_whitepins).sort).to eql(test_whitepins.sort)
      end
    end

    context 'When guess returns both red and whitepins ' do
      it 'The whitepins do not overwrite the redpins' do
        test_code = %w[p g g m]
        test_computer.code = test_code
        test_redpins = [0]
        test_whitepins = %w[g m]
        test_computer.make_code(redpins: test_redpins, whitepins: test_whitepins)
        p test_computer.code
        expect(test_computer.code[0]).to eql(test_code[0])
      end
    end
  end
end

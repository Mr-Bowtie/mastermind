require_relative('../lib/game.rb')

describe Game do
  describe '#generate_keypins' do
    let(:keypins_game) { described_class.new(1, 2) }
    context 'when player enters a valid guess' do
      context 'when player enters the correct code' do
        it 'returns array of red keypins' do
          code = %w[r p o m]
          guess = %w[r p o m]
          keypins_game.generate_keypins(code, guess)
          expect(keypins_game.keypins).to eql(%w[red red red red])
        end
      end

      context 'when player enters 2 fully correct guesses and 2 half correct guesses; code = [r p b g], guess = [r b p g]' do
        it 'returns two red and two white keypins' do
          code = %w[r p b g]
          guess = %w[r b p g]
          keypins_game.generate_keypins(code, guess)
          expect(keypins_game.keypins).to eql(%w[red red white white])
        end
      end

      context 'when a player enters two or more guesses of the same color, ex: [r r o p], [r r r r], etc.' do
        context 'where 1 guess is totally correct, and a second is incorrect; code = [r p b g], guess = [r r m m]' do
          it 'only creates 1 red keypin and no white' do
            code = %w[r p b g]
            guess = %w[r r m m]
            keypins_game.generate_keypins(code, guess)
            expect(keypins_game.keypins).to eql(%w[red])
          end
        end

        context 'where none of the guesses are totally correct, but that color does exist in the secret code; code = [r p b g], guess = [o r r r]' do
          it 'only creates 1 white keypin' do
            code = %w[r p b g]
            guess = %w[o r r r]
            keypins_game.generate_keypins(code, guess)
            expect(keypins_game.keypins).to eql(%w[white])
          end
        end

        context 'where 2 duplicate guesses are totally correct, but the color exists elsewhere in the code; code = [r r r g], guess = [r r o m] ' do
          it 'creates 2 red keypins and no white' do
            code = %w[r r r g]
            guess = %w[r r o m]
            keypins_game.generate_keypins(code, guess)
            expect(keypins_game.keypins).to eql(%w[red red])
          end
        end

        context 'where the duplicate guesses exists in the secret code, but at none of the guessed locations; code = [r p o m], guess = [g r r r]' do
          it 'creates only one white pin' do
            code = %w[r p o m]
            guess = %w[g r r r]
            keypins_game.generate_keypins(code, guess)
            expect(keypins_game.keypins).to eql(%w[white])
          end
        end
      end
    end
  end
end

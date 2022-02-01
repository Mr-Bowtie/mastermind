require 'rainbow'

module Display
  COLORS = { 'r' => Rainbow('  ').bg(:red),
             'p' => Rainbow('  ').bg(:purple),
             'o' => Rainbow('  ').bg(:orange),
             'b' => Rainbow('  ').bg(:blue),
             'm' => Rainbow('  ').bg(:magenta),
             'g' => Rainbow('  ').bg(:green) }.freeze

  def prompt(input)
    puts "==:| #{input}"
  end

  def display_welcome_message
    prompt "Welcome to Mastermind!\n\n"
    prompt "In this game one player creates a secret code madeup of#{Rainbow(' 4 ').bg(:red)}colors from this list:"
    prompt 'red, purple, orange, blue, magenta, and green'
    display_code(COLORS.keys)
    prompt "Then, the other player tries to guess that code before#{Rainbow(' 10 ').bg(:red)}rounds are up."
    prompt 'After each guess, the code breaker will get hints in the form of keypins.'
    prompt "A red pin -#{Rainbow('@').red}- for every guess that is the correct color in the correct position."
    prompt "A white pin -#{Rainbow('@').white}- for every guess that is a correct color, but in the wrong position."
    prompt "Good luck!\n\n"
    prompt 'press Enter to start the game'
    gets.chomp
  end

  def display_replay_message
    prompt 'Would you like to play again? ( yes | no )'
  end

  def display_result(winner, maker_code)
    case winner
    when breaker
      prompt "The #{winner.name} has cracked the code!"
    when maker
      prompt "The #{winner.name}s code remains unbroken."
    end
    prompt 'The secret code was:'
    display_code(maker_code)
  end

  def display_goodbye
    prompt 'Thanks for playing!'
  end

  def display_code(code)
    print '==:| '
    code.each { |e| print COLORS[e] }
    puts ''
  end

  def display_keypins(keypins)
    colored_pins = keypins.map do |key|
      case key
      when 'white'
        Rainbow('@').white
      when 'red'
        Rainbow('@').red
      end
    end
    puts "|: #{colored_pins.join(' ')} :|\n\n"
  end

  def display_roles_message
    prompt 'Would you like to be the code-maker or code-breaker? (enter maker or breaker)' # ! Display
  end

  def display_code_input_message
    prompt 'Input code: Valid options (r, p, o, b, m, g) '
  end
end

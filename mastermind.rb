class Player
    @@AVAILABLE_COLORS = ['r','g','o','m','c','b']
        attr_accessor :code
        def initialize
            @code = []
        end
    
end
    
    class Human < Player
        attr_accessor :role
        def initialize
            super
            @role = ""
        end
        
        def valid_code?
            unless self.code.length == 4
                puts "invalid length"
                return false
            end
            self.code.each_index do |i|
                if @@AVAILABLE_COLORS.include?(self.code[i])
                    next
                else
                    puts "invalid input"
                    return false
                end
                true
            end
        end
        #converts 4 character string input to array for CodeBoard to methods
        def get_code
                print "Please input your code (ex: rgom) "
                self.code = gets.chomp.split('')
        end
    
        def set_role
            puts "Choose game mode: 1 - Codebreaker 2 - Codemaker"
            self.role = gets.chomp
        end
    
    end
    
    class Computer < Player
        attr_accessor :correct_colors, :misplaced_colors, :color_memory, :secret_code
        attr_reader :possible_positions
        def initialize
            super
            @correct_colors = {}
            @misplaced_colors = {}
            @possible_positions = [0, 1, 2, 3]
            @color_memory = Array.new(4, @@AVAILABLE_COLORS)
            @secret_code = []
        end
    
        def gen_random_code
            4.times {self.code.push(@@AVAILABLE_COLORS.sample)}
        end
    
        def get_correct_colors
            for i in 0...secret_code.length
                if self.code[i] == secret_code[i]
                    self.correct_colors[i] = self.code[i]
                end
            end
        end
    
        def get_misplaced_colors
            for i in 0...secret_code.length
                if correct_colors.values.include?(self.code[i]) ||
                     misplaced_colors.values.include?(self.code[i])
                    next
                elsif remaining_colors().include?(self.code[i]) 
                    self.misplaced_colors[i] = self.code[i]
                end
            end
        end
        
        def swap_misplaced_colors
            misplaced_colors.each_key do |j|
                valid_positions = remaining_positions().select {|e| e != j}
                self.code[valid_positions.sample] = self.misplaced_colors[j]
            end
            
        end
        
        def reassign_incorrect_colors
            incorrect_positions = possible_positions - correct_colors.keys - misplaced_colors.keys
            incorrect_positions.each {|e| self.code[e] = color_memory[e].sample}
    
        end
    
        def remaining_colors
            secret_code - correct_colors.values
        end
    
        def remaining_positions
            possible_positions - correct_colors.keys
        end

        def record_used_colors
            for i in 0...secret_code.length
                color_memory[i] = color_memory[i] - [self.code[i]]
            end
        end
    
        def generate_code
            
            if self.code.empty?
                gen_random_code()
                record_used_colors()
                
            else
                get_correct_colors()
                get_misplaced_colors()
                reassign_incorrect_colors()
                unless misplaced_colors.empty?
                    swap_misplaced_colors()
                end
                record_used_colors()
                self.misplaced_colors = {}
                self.correct_colors = {}
            end
          
        end
    end
    
    #requires input in an array
    class CodeBoard
        attr_reader :code, :guess
        attr_accessor :keypins
        def initialize(code, guess)
            @code = code
            @guess = guess
            @keypins = []
        end
    
        def generate_keypins
            correct_colors = []
            misplaced_colors = []
            #first pass finds all colors in the correct position and stores that info
            for i in 0...self.code.length do
                if self.code[i] == self.guess[i]
                    keypins.unshift("*")
                    correct_colors.push(self.guess[i])
                end
            end
            #second pass only records colors present in the code in the wrong position, if they
            #are not duplicates of a correct color, or misplaced color.
            for i in 0...self.code.length do
                if correct_colors.include?(self.guess[i]) || misplaced_colors.include?(self.guess[i])
                    next
                elsif self.code.include?(self.guess[i])
                   self.keypins.push("@")
                   misplaced_colors.push(self.guess[i])
                else
                    next
                end
            end
        end
    
        def display_board
            display_code_colors(guess)
            puts(" | " + keypins.join(" ") + "\n\n")
    
        end
    
        def display_code
            print "The code was: "
            display_code_colors(code)
            puts " "
        end
    
        def display_code_colors(code)
            code.each do |i|
                case i
                when "r"
                    print "  ".bg_red
                when "g"
                    print "  ".bg_green
                when "o"
                    print "  ".bg_orange
                when "m"
                    print "  ".bg_magenta
                when "c"
                    print "  ".bg_cyan
                when "b"
                    print "  ".bg_blue
                else
                    puts "invalid color code input"
                end
            end
        end
    
    
    end
    
    class String
        def bg_red;         "\e[41m#{self}\e[0m" end
        def bg_green;       "\e[42m#{self}\e[0m" end
        def bg_orange;       "\e[43m#{self}\e[0m" end
        def bg_magenta;     "\e[45m#{self}\e[0m" end
        def bg_cyan;        "\e[46m#{self}\e[0m" end
        def bg_blue;      "\e[44m#{self}\e[0m" end
    end
    
    def welcome_screen
        puts """
        Welcome to Mastermind!
        In this game you will face a computer in either making or breaking a code
        The code will consist of 4 colors in any order
        You or the computer will have 12 turns to break the code
        The color options are as follows:
        """
        puts "  ".bg_red + " red"
        puts "  ".bg_green + " green"
        puts "  ".bg_orange + " orange"
        puts "  ".bg_magenta + " magenta"
        puts "  ".bg_cyan + " cyan"
        puts "  ".bg_blue + " blue"
    
        puts """
        Every turn you will get feedback on your guess
        * - for every correct color in the correct position
        @ - for every correct color in the wrong position
        Good luck!
        """
    
    end
    
    
    
    comp = Computer.new
    player = Human.new
    
    welcome_screen()
    
    until player.role == '1' || player.role == '2'
        player.set_role
        #these need to be broken out into methods 
        if player.role == "1"
            comp.gen_random_code
            12.times do |i|
                loop do
                    player.get_code
                    if player.valid_code?
                        break
                    end 
                end
                board = CodeBoard.new(comp.code, player.code)
                board.generate_keypins
                board.display_board
                if board.keypins.join == "****"
                    puts "You cracked the code!"
                    break
                elsif i == 11
                    puts "The computer has beaten you"
                    board.display_code
                end
            end
    
        elsif player.role == "2"
            loop do
                comp.secret_code = player.get_code
                if player.valid_code?
                    break
                end
            end
            12.times do |i|
                comp.generate_code
                board = CodeBoard.new(player.code, comp.code)
                board.generate_keypins
                board.display_board
                if board.keypins.join == "****"
                    puts "Your code has been cracked"
                    break
                elsif i == 11
                    puts "You have defeated the computer!"
                end
    
            end
    
    
        else
            puts "invalid mode selection"
        end
    
    end
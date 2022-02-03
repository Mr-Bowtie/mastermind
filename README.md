# mastermind
This is a project from the Object oriented programming section of The Odin Project: [link](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/mastermind)

**Live demo**: [mastermind repl](https://replit.com/@MrBowtie/mastermind#.replit)
* press the green Run button at the top to start the program

# What is this? 

This program is a command line version of the classic [Mastermind](https://en.wikipedia.org/wiki/Mastermind_(board_game)) game. 
The user plays against a computer which can either attempt to break the players secret code, or create it's own secret code for the player to try and crack

# Features

* color code output using the [rainbow](https://github.com/sickill/rainbow) gem
* a code-solving algorithm which uses feedback from each guess to intelligently crack the players code. 
  * While it is not fully optimized, in my use it has broken every code in 8 guesses or less.

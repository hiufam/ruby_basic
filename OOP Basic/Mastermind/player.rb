class Player
  attr_accessor :game, :role

  def initialize(game)
    @game = game
  end

  def make_guess
    puts "Make guess: (r: #{'■'.colorize(:red)}, g: #{'■'.colorize(:green)}, y: #{'■'.colorize(:yellow)}, b: #{'■'.colorize(:blue)}, m: #{'■'.colorize(:magenta)}, c: #{'■'.colorize(:cyan)})" # rubocop:disable Layout/LineLength

    gets.chomp
  end

  def make_goal
    is_goal_pegs_created = false
    until is_goal_pegs_created
      system('cls')

      puts 'Goal pegs: (length of 4)'

      goal_pegs = gets.chomp
      return goal_pegs unless goal_pegs.empty?

      is_goal_pegs_created = true
    end
  end
end

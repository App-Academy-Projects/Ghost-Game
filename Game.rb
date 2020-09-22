require 'set'
require_relative 'Player.rb'

DICTIONARY_FILE = "dictionary.txt"

# print styles
LINE_WIDTH = 22
ROW_WIDTH = 10

MAX_LOSSES = 5
GHOST = "GHOST"

class Game
    attr_reader :previous_player, :current_player
    def initialize(players)
        @players = []
        raise "Sorry, this game should played at least between 2 players!!" if players.length < 2
        players.each { |name| @players << Player.new(name) }
        @current_player = @players[0]
        @previous_player = @players[1]
        @fragment = ""
        @dictionary = read_dictionary
    end

    def read_dictionary
        dictionary = Set[]
        File.foreach(DICTIONARY_FILE) { |word| dictionary.add(word.chomp) }
        dictionary
    end

    def players_num
        @players.length
    end
    
    def next_player!
        @previous_player = @current_player
        @current_player = @players.rotate![0]
    end
    
    def take_turn(player)
        puts "#{player.name} Your turn !!!"
        guess = get_guess
        player.guess = guess
        if valid_play?(player.guess)
            @fragment += player.guess
            puts "Yeah!! It's a valid guess"
            puts
        else
            player.alert_invalid_guess
            puts
            player.losses += 1
            puts "You are OUT '#{@current_player.name}'!!!" if lost(player)
            @fragment = ""
        end
        sleep(2)
        system("clear")
        puts "Current fragment: '#{@fragment}'"
        puts
    end

    def get_guess
        print "Enter a char: "
        guess = gets.chomp
        while !valid_input?(guess)
            print "Enter a char: "
            guess = gets.chomp
        end
        guess
    end
    
    def valid_input?(guess)
        return guess.length == 1
    end

    def lost(player)
        return player.losses == MAX_LOSSES
    end

    def valid_play?(string)
        return @dictionary.any? { |word| word.start_with?(@fragment + string) }
    end
    
    def play_round
        take_turn(@current_player) if !lost(@current_player)
        display_standings if !lost(@current_player)
        next_player!
    end

    def record(player)
        player_spells = ""
        losses_times = player.losses
        losses_times.times { |i| player_spells += GHOST[i]}
        player_spells
    end

    def welcome
        system("clear")
        puts "Let's play a round of Ghost!"
        display_standings
    end

    def display_standings
        puts "-" * LINE_WIDTH
        puts "#{"Players".ljust(ROW_WIDTH)}| #{"Losses".ljust(ROW_WIDTH)}"
        @players.each do |player|
            puts "-" * LINE_WIDTH
            puts "#{player.name.ljust(ROW_WIDTH)}| #{record(player).ljust(ROW_WIDTH)}"
        end
        puts "-" * LINE_WIDTH
    end
    
    def winner(players)
        players.each { |player| return player if !lost(player) }
    end
    
    def game_over?
        @players.one? { |player| !lost(player) }
    end
    
    def run
        welcome
        play_round while !game_over?
        puts "'#{winner(@players).name}' is the WINNER!"
    end
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new(["John", "Mark", "David", "Jack"])
    g.run
end
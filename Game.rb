require 'set'
require_relative 'Player.rb'

DICTIONARY_FILE = "dictionary.txt"

# print styles
LINE_WIDTH = 55
ROW_WIDTH = 10
COL_WIDTH = 20
GHOST = "GHOST"

class Game
    attr_reader :previous_player, :current_player
    def initialize(players)
        @current_player, @previous_player = players
        @fragment = ""
        @dictionary = read_dictionary
    end

    def read_dictionary
        dictionary = Set[]
        File.foreach(DICTIONARY_FILE) { |word| dictionary.add(word.chomp) }
        dictionary
    end
    
    def next_player!
        @previous_player, @current_player = @current_player, @previous_player
    end
    
    def take_turn(player)
        puts "#{player.name} Your turn !!!"
        print "Enter a string: "
        guess = gets.chomp
        guess = gets.chomp while guess == ""
        player.guess = guess
        if valid_play?(player.guess)
            @fragment += player.guess
            puts "Yeah!! It's a valid guess"
            puts
            puts "Current fragment: '#{@fragment}'"
            puts
        else
            player.alert_invalid_guess
            puts
            player.losses += 1
            puts "#{@current_player.name} You are a '#{record(@current_player)}'"
            @fragment = ""
            return false
        end        
    end
    
    def valid_play?(string)
        return @dictionary.any? { |word| word.start_with?(@fragment + string) }
    end
    
    def play_round
        display_standings
        take_turn(@current_player)
        next_player!
    end

    def record(player)
        player_spells = ""
        losses_times = player.losses
        losses_times.times { |i| player_spells += GHOST[i]}
        player_spells
    end

    def display_standings
        puts "-" * LINE_WIDTH
        puts "#{"Players".ljust(ROW_WIDTH)}| #{@current_player.name.ljust(COL_WIDTH)}| #{@previous_player.name.ljust(COL_WIDTH)}|"
        puts "-" * LINE_WIDTH
        puts "#{"Losses".ljust(ROW_WIDTH)}| #{@current_player.losses.to_s.ljust(COL_WIDTH)}| #{@previous_player.losses.to_s.ljust(COL_WIDTH)}|"
        puts "-" * LINE_WIDTH
    end

    def run
        play_round while @current_player.losses < 5 && @previous_player.losses < 5
    end
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new(Player.new("p1"), Player.new("p2"))
end
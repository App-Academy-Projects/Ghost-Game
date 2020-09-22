require 'set'
require_relative 'Player.rb'

DICTIONARY_FILE = "dictionary.txt"

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
        player.guess = gets.chomp
        if valid_play?(player.guess)
            @fragment += player.guess
            puts "Yeah!! It's a valid guess"
            p
            p "Current fragment: #{@fragment}"
            p
        else
            player.alert_invalid_guess
            return false
        end        
    end
    
    def valid_play?(string)
        return @dictionary.any? { |word| word.start_with?(@fragment + string) }
    end
    
    def play_round
        while true
            take_turn(@current_player)
            next_player!
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new(Player.new("p1"), Player.new("p2"))
end
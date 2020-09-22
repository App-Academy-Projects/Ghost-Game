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
        str = gets.chomp
        if valid_play?(str)
            @fragment += str
            puts "Yeah!! It's a valid guess"
            p @fragment
        else
            puts "Sorry, you didn't get it :("
            return false
        end        
    end
end
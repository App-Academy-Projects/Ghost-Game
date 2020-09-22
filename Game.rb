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
end
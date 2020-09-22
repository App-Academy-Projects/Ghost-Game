require 'set'
require_relative 'Player.rb'

DICTIONARY_FILE = "dictionary.txt"

class Game
    attr_reader :previous_player, :current_player
    def initialize(players)
        @previous_player, @current_player = players
        @fragment = ""
        @dictionary = read_dictionary
    end

    def read_dictionary
        dictionary = Set[]
        File.foreach(DICTIONARY_FILE) { |word| dictionary.add(word.chomp) }
        dictionary
    end
end
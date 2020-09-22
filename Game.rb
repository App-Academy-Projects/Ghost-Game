require 'set'
require_relative 'Player.rb'

DICTIONARY_FILE = "dictionary.txt"

# print styles
LINE_WIDTH = 22
ROW_WIDTH = 10
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
            puts "You are OUT '#{@current_player.name}'!!!"
            @fragment = ""
            return false
        end        
    end
    
    def valid_play?(string)
        return @dictionary.any? { |word| word.start_with?(@fragment + string) }
    end
    
    def play_round
        take_turn(@current_player) if @current_player.losses < 5
        display_standings
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
        puts "#{"Players".ljust(ROW_WIDTH)}| #{"Losses".ljust(ROW_WIDTH)}"
        @players.each do |player|
            puts "-" * LINE_WIDTH
            puts "#{player.name.ljust(ROW_WIDTH)}| #{record(player).ljust(ROW_WIDTH)}"
        end
        puts "-" * LINE_WIDTH
    end

    def run
        display_standings
        play_round while !@players.one? { |player| player.losses < 5 }
    end
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new(["p1", "p2", "p3"])
end
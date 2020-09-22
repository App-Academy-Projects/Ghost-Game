class Player
    attr_reader :name 
    attr_accessor :guess, :losses
    def initialize(name)
        @name = name
        @guess = ""
        @losses = 0
    end

    def alert_invalid_guess
        puts "#{name}! your '#{guess}' is wrong!!"
        p
    end
end
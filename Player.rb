class Player
    attr_reader :name 
    attr_accessor :guess
    def initialize(name)
        @name = name
        @guess = ""
    end

    def alert_invalid_guess
        puts "#{name}! your '#{guess}' is wrong!!"
        p
    end
end
class Player
    attr_reader :name 
    attr_accessor :guess, :losses_num
    def initialize(name)
        @name = name
        @guess = ""
        @losses_num = 0
    end

    def alert_invalid_guess
        puts "#{name}! your '#{guess}' is wrong!!"
        p
    end
end
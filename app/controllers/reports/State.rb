require_relative '../../../env.rb'

module State
    def generate state_arg
        @result = []
        if state_arg
            @result = CONNECTION.exec("SELECT * FROM offices WHERE state='#{state_arg.upcase}'")
            if @result.first
                @result = [@result]
            else
                return false
            end
        else
            CONNECTION.exec('SELECT DISTINCT state FROM offices;').each do |state|
                @result << CONNECTION.exec("SELECT * FROM offices WHERE state='#{state['state']}'")
            end
        end

        return true
    end
end
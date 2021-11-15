require_relative '../../env.rb'

class StateReport
    def view_file filename
        File.read(filename)
    end

    def render filename
        ERB.new(view_file(filename)).result(get_binding)
    end

    def get_binding
        binding
    end

    def call(env)
        status  = 200
        headers = { "Content-Type" => "text/html" }
        @result = []
        if env['rack.route_params'][:state]
            @result = CONNECTION.exec("SELECT * FROM offices WHERE state='#{env['rack.route_params'][:state].upcase}'")
            if @result.first
                @result = [@result]
            else
                return [404, headers, [render('views/404.erb')]]
            end
        else
            CONNECTION.exec('SELECT DISTINCT state FROM offices;').each do |state|
                @result << CONNECTION.exec("SELECT * FROM offices WHERE state='#{state['state']}'")
            end
        end
        
        body    = [render('views/state_report.erb')]
        
        [status, headers, body]
    end
end
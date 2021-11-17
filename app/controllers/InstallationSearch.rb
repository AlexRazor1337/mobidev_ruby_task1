require_relative '../../env.rb'

class InstallationSearch
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
        @result = CONNECTION.exec('SELECT DISTINCT * FROM offices;')
        
        body    = [render('views/installation_search.erb')]
        
        [status, headers, body]
    end
end

require_relative '../../env.rb'

class BaseController
    def initialize(template)
        @status = 200
        @template = template
    end
    
    def view_file filename
        File.read(filename)
    end

    def render filename
        ERB.new(view_file(filename)).result(get_binding)
    end

    def get_binding
        binding
    end

    def perform
        raise NotImplementedError, "Subclasses must define `perform`."
    end

    def call(env)
        status  = @status
        headers = { "Content-Type" => "text/html" }
    
        perform(env)

        [status, headers, [render(@template)]]
    end
end
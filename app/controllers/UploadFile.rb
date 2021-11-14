require_relative '../../load.rb'

class UploadFile
    def view_file
        File.read('views/uploaded.erb')
    end

    def render
        ERB.new(view_file).result(get_binding)
    end

    def get_binding
        binding
    end

    def call(env)
        request = Rack::Request.new(env)
        if request.post? && request.params['file']
            @status = 'Success!'
            load(request.params['file'][:tempfile])
        else
            @status = 'Something went wrong'
        end

        status  = 200
        headers = { "Content-Type" => "text/html" }
        body    = [render()]

        [status, headers, body]
    end
end
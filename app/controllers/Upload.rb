class Upload
    def view_file
        File.read('views/upload.erb')
    end

    def render
        ERB.new(view_file).result(get_binding)
    end

    def get_binding
        binding
    end

    def call(env)
        status  = 200
        headers = { "Content-Type" => "text/html" }
        body    = [render()]

        [status, headers, body]
    end
end
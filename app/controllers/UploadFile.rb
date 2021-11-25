require_relative '../../load.rb'
require_relative 'BaseController.rb'

class UploadFile < BaseController
    def initialize template
        super
    end

    def perform env
        request = Rack::Request.new(env)
        if request.post? && request.params['file']
            @result = 'Success!'
            load(request.params['file'][:tempfile])
        else
            @result = 'Something went wrong'
        end
    end
end
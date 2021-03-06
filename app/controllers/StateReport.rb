require_relative 'BaseController.rb'
require_relative 'reports/State.rb'

class StateReport < BaseController
    include State
    def initialize template
        super
    end

    def perform env
        if !generate(env['rack.route_params'][:state])
            @status = 404
            @template = 'views/404.erb'
        end
    end
end
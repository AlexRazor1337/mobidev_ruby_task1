require_relative 'BaseController.rb'
require_relative 'reports/OfficeInstallation.rb'

class OfficeInstallationReport < BaseController
    include OfficeInstallation
    def initialize template
        super
    end

    def perform env
        if !generate(env['rack.route_params'][:id])
            @status = 404
            @template = 'views/404.erb'
        end
    end
end

require_relative '../../env.rb'
require_relative 'BaseController.rb'

class InstallationSearch < BaseController
    def initialize template
        super
    end

    def perform env
        @result = CONNECTION.exec('SELECT DISTINCT * FROM offices;')
    end
end

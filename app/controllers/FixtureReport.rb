require_relative 'BaseController.rb'
require_relative 'reports/Fixture.rb'

class FixtureReport < BaseController
    include Fixture
    def initialize template
        super
    end

    def perform env
        generate env['rack.route_params'][:id]
    end
end
require_relative 'BaseController.rb'
require_relative 'reports/MaterialCost.rb'

class MaterialCostReport < BaseController
    include MaterialCost
    def initialize template
        super
    end

    def perform env
        generate
    end
end
require 'rack'
require 'rack/router'
require_relative '../db.rb'
require_relative 'controllers/Home.rb'
require_relative 'controllers/Upload.rb'
require_relative 'controllers/UploadFile.rb'
require_relative 'controllers/StateReport.rb'
require_relative 'controllers/FixtureReport.rb'
require_relative 'controllers/MaterialCostReport.rb'
require_relative 'controllers/OfficeInstallationReport.rb'
require_relative 'controllers/InstallationSearch.rb'

prepareDB()
use(Rack::Static, :urls => ["/css"], :root => "assets")

app = Rack::Router.new {
    get '/' => Home.new('views/home.erb')
    get '/upload' => Upload.new('views/upload.erb')
    post '/upload' => UploadFile.new('views/uploaded.erb')
    get '/reports/states' => StateReport.new('views/state_report.erb')
    get '/reports/states/:state' => StateReport.new('views/state_report.erb')
    get '/reports/offices/:id/fixture_types' => FixtureReport.new('views/fixture_sub.erb')
    get '/reports/offices/fixture_types' => FixtureReport.new('views/fixture_count.erb')
    get '/reports/material_cost' => MaterialCostReport.new('views/material_cost.erb')
    get '/reports/offices/:id/installation' => OfficeInstallationReport.new('views/installation.erb')
    get '/installation' => InstallationSearch.new('views/installation_search.erb')
    get '*' => Home.new('views/home.erb')
}

run app

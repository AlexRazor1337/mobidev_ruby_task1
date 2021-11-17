require 'rack'
require 'rack/router'
require_relative '../db.rb'
require_relative 'controllers/Home.rb'
require_relative 'controllers/Upload.rb'
require_relative 'controllers/UploadFile.rb'
require_relative 'controllers/StateReport.rb'
require_relative 'controllers/FixtureReport.rb'
require_relative 'controllers/MaterialCost.rb'
require_relative 'controllers/OfficeInstallation.rb'
require_relative 'controllers/InstallationSearch.rb'

prepareDB()
use(Rack::Static, :urls => ["/css"], :root => "assets")

app = Rack::Router.new {
    get '/' => Home.new
    get '/upload' => Upload.new
    post '/upload' => UploadFile.new
    get '/reports/states' => StateReport.new
    get '/reports/states/:state' => StateReport.new
    get '/reports/offices/:id/fixture_types' => FixtureReport.new
    get '/reports/offices/fixture_types' => FixtureReport.new
    get '/reports/material_cost' => MaterialCost.new
    get '/reports/offices/:id/installation' => OfficeInstallation.new
    get '/installation' => InstallationSearch.new
    get '*' => Home.new
}

run app

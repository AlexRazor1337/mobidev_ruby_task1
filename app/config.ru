require 'rack'
require 'rack/router'
require_relative '../db.rb'
require_relative 'controllers/Home.rb'
require_relative 'controllers/Upload.rb'
require_relative 'controllers/UploadFile.rb'

prepareDB()
use(Rack::Static, :urls => ["/css"], :root => "assets")

app = Rack::Router.new {
    get '/' => Home.new
    get '/upload' => Upload.new
    post '/upload' => UploadFile.new
    get '/reports/states' => StateReport.new
    get '/reports/states/:state' => StateReport.new
}

run app

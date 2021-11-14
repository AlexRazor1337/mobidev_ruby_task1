require 'rack'
require 'rack/router'
require_relative '../db.rb'
require_relative 'controllers/Home.rb'
require_relative 'controllers/Upload.rb'
require_relative 'controllers/UploadFile.rb'
# require_relative('../env.rb')
prepareDB()
use(Rack::Static, :urls => ["/css"], :root => "assets")

app = Rack::Router.new {
    get '/' => Home.new
    post '/' => Home.new
    get '/upload' => Upload.new
    post '/upload' => UploadFile.new
}

run app

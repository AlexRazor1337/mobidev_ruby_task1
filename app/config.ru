require 'rack'
require 'rack/router'
require_relative 'controllers/Home.rb'
# require_relative('../env.rb')

use(Rack::Static, :urls => ["/css"], :root => "assets")

app = Rack::Router.new {
    get '/' => Home.new
    post '/' => Home.new
}

run app

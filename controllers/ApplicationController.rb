class ApplicationController < Sinatra::Base
  require 'bundler'
  Bundler.require()

  require 'net/http'
  
  require 'dotenv'
  require './config/environments'

  Dotenv.load()

  use Rack::Session::Cookie,  :key => 'rack.session',
                              :path => '/',
                              :secret => 'ownfojnoejnfew'

  use Rack::MethodOverride
  set :method_override, true

  set :views, File.expand_path('../../views', __FILE__)

  set :public_dir, File.expand_path('../../Public', __FILE__)

#splash page route
  get '/' do    
    redirect '/users/login'
  end


  get '/test' do
    some_text = "Lets go on an Adventure!"
    binding.pry 
    "pry has finished -- here's some_text #{some_text}"
  end

  get '*' do
     halt 404
    
  end

end
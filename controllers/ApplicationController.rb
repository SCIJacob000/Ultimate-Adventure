class ApplicationController < Sinatra::Base
  require 'bundler'
  Bundler.require()

  require './config/environments'

  enable :sessions

  ActiveRecord::Base.establish_connection(
  	:adapter => 'postgresql',
  	:database => 'show_stopper'
  )

  use Rack::MethodOverride
  set :method_override, true

  set :views, File.expand_path('../../views', __FILE__)


  set :public_dir, File.expand_path('../../public', __FILE__)

#splash page route
  get '/' do    
    redirect '/trips'
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
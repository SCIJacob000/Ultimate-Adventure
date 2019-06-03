require 'sinatra/base'

require './controllers/ApplicationController'
require './controllers/UserController'

require './models/UserModel'


map ('/') {
	run ApplicationController
}
map ('/users') {
	run UserController
}
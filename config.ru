require 'sinatra/base'

require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/TripController'
require './controllers/StopController'

require './models/UserModel'
require './models/TripModel'
require './models/StopModel'
require './models/BookingModel'


map ('/') {
	run ApplicationController
}
map ('/users') {
	run UserController
}
map ('/trips') {
	run TripController
}
map ('/stops') {
	run StopController
}
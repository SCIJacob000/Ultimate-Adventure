class TripController < ApplicationController

get '/:id/edit' do 
	@trip = Trip.find params[:id]
	erb :trip_edit
end

put '/:id' do 
	@trip = Trip.find params[:id]
	trip.name = params[:name]
	trip.save
	redirect "/users/#{session[:user_id]}"
end 

delete '/:id' do 
	trip = Trip.find params[:id]
	bookings = trip.bookings
	bookings.destroy
	trip.destroy
	redirect "/users/#{session[:user_id]}"
end

get '/:id' do 
	@trip = Trip.find params[:id]
	@stops = @trip.stops
	session[:trip_id] = params[:id]
	erb :trip_show
end 

post '/' do
puts "you are hitting the route" 
	new_trip = Trip.new 
	new_trip.name = params[:name]
	new_trip.user_id = session[:user_id]
	new_trip.save
	session[:message]= {
		success: true,
		message: "#{new_trip.name} successfully created!"
	}
	redirect "/users/#{session[:user_id]}"
end

end
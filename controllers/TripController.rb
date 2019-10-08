class TripController < ApplicationController

get '/:id/edit' do 
	user = User.find session[:id]
	@user = User.find session[:id]
	@trips_nav = user.trips
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
		trip.destroy
		session[:message]={
			message: "Trip has been destroyed"
		}
	redirect "/users/#{session[:user_id]}"
end

get '/:id' do 
	@user = User.find session[:user_id]
	user = User.find session[:user_id]
	@trips_nav = user.trips
	@trip = Trip.find params[:id]
	@stops = @trip.stops
	session[:trip_view] = true	
	erb :trip_show
end 

post '/' do 
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
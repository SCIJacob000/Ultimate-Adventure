class StopController < ApplicationController
#post route that makes a stop if it does not exist already as well as a booking
#to associate that stop with the desired trip
get '/1' do
	case params[:state]
		when "Alabama"
			state_code = "AL"
		when "Arizona"
			state_code = "AZ"
		when "Arkansas"
			state_code = "AR"
		when "California"
			state_code = "CA"
		when "Colorado"
			state_code = "CO"
		when "Connecticut"
			state_code = "CT"
		when "Delaware"
			state_code = "DE"
		when "Florida"
			state_code = "FL"
		when "Georgia"
			state_code = "GA"
		when "Idaho"
			state_code = "ID"
		when "Illinois"
			state_code = "IL"
		when "Indiana"
			state_code = "IN"
		when "Iowa"
			state_code = "IA"
		when "Kansas"
			state_code = "KS"
		when "Kentucky"
			state_code = "KY"
		when "Louisiana"
			state_code = "LA"
		when "Maine"
			state_code = "ME"
		when "Maryland"
			state_code = "MD"
		when "Massachusetts"
			state_code = "MA"
		when "Michigan"
			state_code = "MI"
		when "Minnesota"
			state_code = "MN"
		when "Mississippi"
			state_code = "MS"
		when "Missouri"
			state_code = "MO"
		when "Montana"
			state_code = "MT"
		when "Nebraska"
			state_code = "NE"
		when "Nevada"
			state_code = "NV"
		when "New Hampshire"
			state_code = "NH"
		when "New Jersey"
			state_code = "NJ"
		when "New Mexico"
			state_code = "NM"
		when "New York"
			state_code = "NY"
		when "North Carolina"
			state_code = "NC"
		when "North Dakota"
			state_code = "ND"
		when "Ohio"
			state_code = "OH"
		when "Oklahoma"
			state_code = "OK"
		when "Oregon"
			state_code = "OR"
		when "Pennsylvania"
			state_code = "PA"
		when "Rhode Island"
			state_code = "RI"
		when "South Carolina"
			state_code = "SC"
		when "South Dakota"
			state_code = "SD"
		when "Tennessee"
			state_code = "TN"
		when "Texas"
			state_code = "TX"
		when "Utah"
			state_code = "UT"
		when "Vermont"
			state_code = "VT"
		when "Virginia"
			state_code = "VA"
		when "Washington"
			state_code = "WA"
		when "West Virginia"
			state_code = "WV"
		when "Wisconsin"
			state_code = "WI"
		when "Wyoming"
			state_code = "WY"
	end
	session[:state_code] = state_code
	session[:search] = 1
	uri = URI("https://developer.nps.gov/api/v1/parks?stateCode=#{state_code}&api_key=#{ENV['NPS_API_KEY']}")
	it = Net::HTTP.get(uri) # => String
	parsed_it = JSON.parse it
	@parks = parsed_it["data"]
	@user = User.find session[:user_id]
	erb :user_show
end

get '/2' do 
	search_term = params[:input]
	session[:search_term] = search_term
	session[:search] = 2
	uri = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{search_term}&inputtype=textquery&&fields=formatted_address,name,rating,price_level&&key=AIzaSyC8MsmCzboLdVxigIdsbYS8wnNNxR2XNYs")
	it = Net::HTTP.get(uri)
	parsed_it = JSON.parse it 
	@places = parsed_it["results"]
	@user = User.find session[:user_id]
	erb :user_show

end

#delete to delete stops from a trip
delete '/:id/:trip_id' do 
	trip = Trip.find_by id: params[:trip_id] #this is the trip the stop is being deleted from
	stop = Stop.find params[:id]#this is the stop to be deleted
	booking_to_delete = Booking.find_by(trip_id: trip.id, stop_id: stop.id) #this should work as it finds the booking associated with both the trip and the stop
	if booking_to_delete 
		booking_to_delete.destroy
		stop.destroy
		redirect "/users/#{session[:user_id]}"
	else
		session[:message] = {
			success: true,
			message: "Sorry You Cant Do That"
		}
		redirect "/users/#{session[:user_id]}"
	end	
end

post '/:stop_name/:index' do 
	@trip = Trip.find_by name: params[:name]
	stop = Stop.find_by name: params[:stop_name]
	i = params[:index].to_i #this should represent the index number of the stop to be created in the array of results from api
	#might have to "redo" the http requests here and pass i to the backend using params to filter the info you want as i will be the dynamic part of the equation!
	if !stop
		if session[:search] == 1
			uri = URI("https://developer.nps.gov/api/v1/parks?stateCode=#{session[:state_code]}&api_key=#{ENV['NPS_API_KEY']}")
			it = Net::HTTP.get(uri) # => String
			parsed_it = JSON.parse it
			@parks = parsed_it["data"]
			new_stop = Stop.new
			#build the new entry based on what is returned from the http request... may have to make the same request as results lists
			new_stop[:name] = @parks[i]["fullName"]
			new_stop[:lat_long] = @parks[i]["latLong"].delete "lat:" " " "long:"
			puts "this should be the correctly formated lat long values as a string"
			puts new_stop[:lat_long]
			new_stop.save
			new_booking = Booking.new 
			new_booking[:trip_id] = @trip[:id]#we will send info back in params to fill in this field
			new_booking[:stop_id] = new_stop[:id]
			new_booking[:user_id] = session[:user_id]
			new_booking.save
			redirect "/trips/#{@trip[:id]}"  
		elsif session[:search] == 2
			uri = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{session[:search_term]}&inputtype=textquery&&fields=formatted_address,name,rating,price_level&&key=AIzaSyC8MsmCzboLdVxigIdsbYS8wnNNxR2XNYs")
			it = Net::HTTP.get(uri)
			parsed_it = JSON.parse it 
			@places = parsed_it["results"]
			new_stop_place = Stop.new
			#build the new entry based on what is returned from the http request... may have to make the same request as results lists
			new_stop_place[:name] = @places[i]["name"]
			new_stop_place[:address] = @places[i]["formatted_address"]
			new_stop_place[:lat_long] = @places[i]["geometry"]["location"]["lat"].to_s + "," + @places[i]["geometry"]["location"]["lng"].to_s
			puts new_stop_place[:lat_long]
			new_stop_place.save
			new_booking_place = Booking.new
			new_booking_place[:trip_id] = @trip[:id]
			new_booking_place[:stop_id] = new_stop_place[:id] 
			new_booking_place[:user_id] = session[:user_id]
			new_booking_place.save
			redirect "/trips/#{@trip[:id]}" 
		end
	else
		new_booking = Booking.new
		new_booking[:trip_id] = @trip[:id]
		new_booking[:stop_id] = stop[:id]
		new_booking[:user_id] = session[:user_id]
		new_booking.save
		redirect "/trips/#{@trip[:id]}"
	end
end
end
class UserController < ApplicationController

get '/register' do
	@user = {}
	@trips_nav = []
	if session[:attempted_reg] == true
		session[:message] = {
			success: false,
			message: "Sorry A User With That Name Already Exists Please Choose Another and Try Again"
		}
	session[:logged] = false
	erb :user_register
	else
		session[:message]={
			message: "Enter your Info to Register"
		}
		session[:logged] = false
		erb :user_register
	end
end

get '/logout' do 
	username = session[:username]
	session.destroy
	session[:logged] = false
	session[:message] = {
		success: true,
		message: "Have Fun and Drive Safely #{username}!"
	}
	session[:attempted_log] = false
	redirect '/users/login'
end

get '/:id/edit' do 
	@user = User.find params[:id]
	@trips_nav = @user.trips
	erb :user_edit
end


get '/login' do 
	@user = {}
	@trips_nav = []

	if session[:attempted_log] == true
		session[:message] = {
			success: false,
			message: "Invalid Login Credentials Please Try Again"
		}
		erb :user_login
	else
		session[:message]={
			message: "Enter your Info to Log-In"
		}
		erb :user_login
	end
end

post '/login' do
	user = User.find_by username: params[:username]
	pw = params[:password]
	if user && user.authenticate(pw)
		session[:logged] = true
		session[:username] = user[:name]
		session[:user_id] = user[:id]
		session[:search] = 0
		session[:logged] = true
		session[:message] = {
			success: true,
			message: "#{user.username} has successfully logged in!"
		}
		redirect "/users/#{session[:user_id]}"
	else
		session[:attempted_log] = true
		redirect '/users/login'
	end
end

post '/register' do 
	user = User.find_by username: params[:username]

	if !user
		
		user = User.new
		user.username = params[:username]
		user.password = params[:password]
		user.save
			session[:logged] = true
			session[:username] = user.username
			session[:user_id] = user.id
			session[:search] = 0
			session[:message] = {
				success: true,
				message: "#{user.username} has successfully logged in!"
		}
		redirect "/users/#{session[:user_id]}"
	else
		session[:attempted_reg] = true
		redirect '/users/register'

	end
end



put '/:id' do 
	user = User.find params[:id]
	user.username = params[:username]
	user.password = params[:password]
	user.save
		session[:message] = {
			success: true,
			message: "#{user.username}'s info has successfully updated"
		}
	redirect "users/#{user.id}"
end


get '/:id' do 
	 @user = User.find params[:id]
	 trips = @user.trips
	 @trips_nav = @user.trips
	 @parks = []
	 @places = []
	 session[:search] = 0
	 session[:tripview]= false
	 erb :user_show
end


delete '/:id' do 
	user = User.find params[:id]
	user.destroy
	redirect '/users/register'
end

end





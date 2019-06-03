class UserController < ApplicationController

get '/register' do
	erb :user_register
end

get '/logout' do 
	username = session[:username]
	session.destroy
	session[:message] = {
		success: true,
		message: "Have Fun and Drive Safely #{username}!"
	}
	redirect '/users/login'
end

get '/:id/edit' do 
	@user = User.find params[:username]
	erb :user_edit
end

get '/login' do 
	erb :user_login
end

post '/login' do
	user = User.find_by username: params[:username]
	pw = params[:password]
	if user && user.authenticate(pw)
		session[:logged_in] = true
		session[:username] = user.username
		session[:user_id] = user.id
		session[:message] = {
			success: true,
			message: "#{user.username} has successfully logged in!"
		}
		redirect "/users/#{session[:user_id]}"
	else
		session[:message] = {
			success: false,
			message: "Invalid Login Credentials Please Try Again"
		}
		redirect '/users/login'
	end
end

post '/register' do 
	user = User.find_by username: params[:username]

	if !user
		user = User.new
		user.username = params[:username]
		user.password = params[:password]
		user.image = params[:image]
		user.save
			session[:logged_in] = true
			session[:username] = user.username
			session[:user_id] = user.id
			session[:message] = {
				success: true,
				message: "#{user.username} has successfully logged in!"
		}
		redirect "/users/#{session[:user_id]}"
	else
		session[:message] = {
			success: false,
			message: "Sorry A User With That Name Already Exists Please Choose Another and Try Again"
		}
		redirect '/users/register'

	end
end

get '/:id' do 
	 @user = User.find params[:id]

	 puts "user"
	 puts @user

	 trips = @user.trips
	 erb :user_show
end

put '/:id' do 
	user = User.find params[:id]
	user.username = params[:username]
	user.password = params[:password]
	user.image = params[:image_url]
	user.save
		session[:message] = {
			success: true,
			message: "#{user.username}'s info has successfully updated"
		}
		redirect 'users/:id'
end

delete '/:id' do 
	user = User.find params[:id]
	user.destroy
	redirect '/users/register'
end

#possibly need this route to have a page where users can check out other users trips

get '/' do 
	@users = User.all
	erb :user_index
end

end





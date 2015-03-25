class UsersController < ApplicationController
  
  #only before new action, call skip_to_refer
  before_action :skip_to_refer, :only => :new

  def new
		@user = User.new
	end

	def create
		#find a User with the same email
		@user = User.find_by_email(:email)

		#if User does not exist
		if @user.nil?
			#create a new instance of User with email
			@user = User.new(user_params)
		
			#get the User with the same referral code as in the cookies hash
			@referred_by = User.find_by_referral_code(cookies[:h_ref])

			#if User found, set current User's referrer
			if !@referred_by.nil?
				@user.referrer = @referred_by
			end

			#save instance of current user
			@user.save

			#delete referral code in cookies hash
			cookies.delete :h_ref

	  end
		#save current User's email in cookies hash for access in refer action
		cookies[:h_email] = {value: @user.email}
			
		#redirect to refer action (i.e. main referrable page)
		redirect_to '/refer-a-friend'			
	end

	def refer
		#retreive the current User's email from the cookies hash
		email = cookies[:h_email]

		#retreive current User
		@user = User.find_by_email(email)

		#if User not found
		if @user.nil?
			redirect_to root_path
		end
	end

	def skip_to_refer
    email = cookies[:h_email]
    if email and !User.find_by_email(email).nil?
      redirect_to '/refer-a-friend'
    else
      cookies.delete :h_email
    end 
	end

	private
	def user_params
		params.require(:user).permit(:email)
	end

end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ref_to_cookies

  protected
  #method to save query string (?ref=) in cookies hash
  def ref_to_cookies
  	#if query string exists
  	if params[:ref]
  	  #if a User with the same referral code as in query string value found
      if !User.find_by_referral_code(params[:ref]).nil?
      	#save the value of the query string in the cookies hash
        cookies[:h_ref] = {value: params[:ref]}
      end
    end
  end

end

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: "User", foreign_key: "referrer_id"
  has_many :referrals, class_name: "User", foreign_key: "referrer_id"

  validates :email, uniqueness: true
  validates :referral_code, uniqueness: true

  before_create :create_referral_code

  private
  def create_referral_code
  	#generate random hexadecimal referral code
    referral_code = SecureRandom.hex(5) 
    #find other user with the same referral code, if any
    @collision = User.find_by_referral_code(referral_code)
    #while other users with the same referral code are found
    while !@collision.nil?
    	#re-generate the referral code
    	referral_code = SecureRandom.hex(5)
    end
    #unique referral code generated; save to current user
    self.referral_code = referral_code
  end
end

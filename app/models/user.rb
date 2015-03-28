class User < ActiveRecord::Base
  belongs_to :referrer, class_name: "User", foreign_key: "referrer_id"
  has_many :referrals, class_name: "User", foreign_key: "referrer_id"

  validates :email, :username, uniqueness: true
  validates :referral_code, uniqueness: true

  before_create :create_referral_code

  REFERRAL_STEPS = [
    {
        'count' => 5,
        "html" => "Coffee<br>Mug",
        "class" => "two",
        "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
    },
    {
        'count' => 10,
        "html" => "Pizza",
        "class" => "three",
        "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
    },
    {
        'count' => 25,
        "html" => "Lunch with Walter",
        "class" => "four",
        "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
    },
    {
        'count' => 50,
        "html" => "Free<br>Wyncode",
        "class" => "five",
        "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
    }
  ]

  def admin?
    self.role == 'admin'
  end

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

class User < ActiveRecord::Base

    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email
    attr_accessible :first_name

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :add_to_infusionsoft

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Hand<br>Wraps",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("refer/wraps.jpg")
        },
        {
            'count' => 10,
            "html" => "Water<br>Bottle",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("refer/bottle.jpg")
        },
        {
            'count' => 25,
            "html" => "Boxing<br>Gloves",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("refer/gloves.jpg")
        },
        {
            'count' => 50,
            "html" => "One Month<br>of Membership",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("refer/1month.jpg")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end

    def add_to_infusionsoft
        Infusionsoft.contact_add({:FirstName => self.first_name, :ReferralCode => self.referral_code ,:Email => self.email})
        Infusionsoft.email_optin(self.email, "Opted In through Prelaunchr")
    end
end

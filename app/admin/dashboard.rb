ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
 

    # Here is an example of a simple dashboard with columns and panels.
    #
    users_with_referrals = User.all
    no_prize_users = []
    prize_1_users = []
    prize_2_users = []
    prize_3_users = []
    prize_4_users = []

    users_with_referrals.each do |user|
      if user.referrals.count.between?(1,4)
        no_prize_users << user
      elsif user.referrals.count.between?(5,9)
        prize_1_users << user

      elsif user.referrals.count.between?(10,24)
        prize_2_users << user

      elsif user.referrals.count.between?(25,49)
        prize_3_users << user

      elsif user.referrals.count >= 50
        prize_4_users << user

      end





    end

    columns do
      show_referral_table("Users with at 1-4 referral", no_prize_users)
      show_referral_table("Users with at 5-9 referral", prize_1_users)
      show_referral_table("Users with at 10-24 referral", prize_2_users)
      show_referral_table("Users with at 25-49 referral", prize_3_users)
      show_referral_table("Users with great than 50 referral", prize_4_users)
    end

  end # content
end




def show_referral_table (name, users)
  column do
    section "#{users.count} #{name}"  do  
      table_for users do
        show_prize
      end
    end
  end
end

def show_prize
  column :email do |user|  
      link_to user.email, admin_user_path(user)  
  end  
  column "Referral Count" do |user|
    user.referrals.count  
  end
end

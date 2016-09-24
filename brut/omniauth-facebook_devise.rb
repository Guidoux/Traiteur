gem 'omniauth-facebook'
run 'rails g migration AddOmniauthToUsers provider:string uid:string'
rake 'db:migrate'

inject_into_file 'config/initializers/devise.rb', 
	"  config.omniauth :facebook, Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, scope: 'email', info_fields: 'email,name'\n",
	after: "Devise.setup do |config|\n"
inject_into_file 'app/models/user.rb', 
	" :omniauthable, :omniauth_providers => [:facebook]\n",
	after: ", :validatable,\n"
inject_into_file 'config/routes.rb',
	", :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }\n",
	after: 'devise_for :users'

run 'mkdir app/controllers/users '
run 'touch app/controllers/users/omniauth_callbacks_controller.rb'

inject_into_file 'app/controllers/users/omniauth_callbacks_controller.rb', before: /^.*$/m do <<-'CALLBACK'
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
CALLBACK
end	

inject_into_file 'app/models/user.rb', after: ":omniauthable, :omniauth_providers => [:facebook]\n" do <<-'METHODS'
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
METHODS
end	

inject_into_file 'config/secrets.yml', after: "development:\n" do <<-'ENV'
  facebook_app_id: <%= ENV["FACEBOOK_APP_ID"] %>
  facebook_app_secret: <%= ENV["FACEBOOK_APP_SECRET"] %>
ENV
end

inject_into_file 'config/secrets.yml', after: "test:\n" do <<-'EOF'
  facebook_app_id: <%= ENV["FACEBOOK_APP_ID"] %>
  facebook_app_secret: <%= ENV["FACEBOOK_APP_SECRET"] %>
EOF
end
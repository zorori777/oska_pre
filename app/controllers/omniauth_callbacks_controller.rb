class OmniauthCallbacksController <  Devise::OmniauthCallbacksController

  def line; basic_action end

  private

  def basic_action
    @omniauth = request.env['omniauth.auth']
    if @omniauth.present?
      @profile = SocialProfile.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
      if @profile
        @profile.set_values(@omniauth)
      else
        @profile = SocialProfile.new(provider: @omniauth['provider'], uid: @omniauth['uid'])
         @profile.user = current_user || User.create!(name: @omniauth["info"]["name"])
        @profile.set_values(@omniauth)
        redirect_to new_post_path and return
      end
    end
    redirect_to new_post_path
  end
end

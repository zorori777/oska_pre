class User < ApplicationRecord
  devise :omniauthable

  has_many :social_profiles, dependent: :destroy
  has_many :pictures
  
  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end
end

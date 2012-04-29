class User < ActiveRecord::Base
  validates :github_uid, :username, :uniqueness => true, :presence => true
  validates :email, :format => { :with => /\A[^@]+@[^@]+\z/ }, :uniqueness => true, :allow_blank => true

  attr_accessible :avatar_url, :email, :name, :site_url, :username, :github_uid

  def self.create_from_github( omniauth )
    user_info = omniauth['info']
    extras    = omniauth['extra']['raw_info']

    User.new.tap do |user|
      user.github_uid     = omniauth['uid']
      user.username       = user_info['nickname']
      user.email          = user_info['email']
      user.name           = user_info['name']

      if extras
        user.site_url       = extras['blog']
        user.gravatar_token = extras['gravatar_id']
      end

      user.save!
    end
  end
end
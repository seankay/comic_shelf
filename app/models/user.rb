class User < ActiveRecord::Base
  belongs_to :store, :dependent => :delete
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  def set_roles(roles)
    roles.each do |r|
      spree_roles << Spree::Role.find_or_create_by_name(r.to_s)
    end
  end

  def has_role? role
    spree_roles.each do |r|
      return true if r.name.eql?(role.to_s)
    end
    false
  end
end

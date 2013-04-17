class Store < ActiveRecord::Base
  has_many :spree_users, class_name: "Spree::User"
  has_one :subscription
  attr_accessible :name, :subdomain

  before_validation :create_subdomain
  before_save :create_database
  after_create :switch_database

  ALLOWED_NAMES = /([0-9a-z]*\-[0-9a-z]*)*/i
  ALLOWED_SUBDOMAINS = /[^0-9a-zA-Z]/
  validates :name, :format => { :with => ALLOWED_NAMES }, 
    :presence => true, :length => { :minimum => 3, :maximum => 40 }
  validates :subdomain, :format => { :with => ALLOWED_NAMES }, :uniqueness => true,
    :presence => true, :length => { :minimum => 3 , :maximum => 40 }

  def error_reasons 
    "The store's #{errors.full_messages.first}"
  end

  def database
    subdomain
  end

  private

  def create_subdomain
    self.subdomain = name.gsub(ALLOWED_SUBDOMAINS, "").downcase if name
  end
  
  def create_database
    DatabaseUtility.create(subdomain) unless DatabaseUtility.exists?(subdomain)
  end

  def switch_database
    DatabaseUtility.switch(database)
  end
end

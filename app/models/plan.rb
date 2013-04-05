class Plan < ActiveRecord::Base
  has_many :subscriptions
  validates_presence_of :name, :price, :max_products, :plan_identifier
  attr_accessible :max_products, :name, :price, :plan_identifier
end

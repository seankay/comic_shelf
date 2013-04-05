Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

plans = [
  { :name => "Low Plan", :price => "10", :max_products => 1, :plan_identifier => "low_plan"},
  { :name => "Mid Plan", :price => "25", :max_products => 5, :plan_identifier => "mid_plan"},
  { :name => "High Plan", :price => "50", :max_products => 10, :plan_identifier => "high_plan"}
]

plans.each do |plan|
  Plan.find_or_create_by_plan_identifier(plan)
end


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

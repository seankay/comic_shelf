# module Spree
#   HomeController.class_eval do
#     helper 'spree/products'
#     respond_to :html

#     def index
#       @searcher = Spree::Config.searcher_class.new(params)
#       @searcher.current_user = try_spree_current_user
#       @searcher.current_currency = current_currency
#       @products = @searcher.retrieve_products
#     end
#   end
# end

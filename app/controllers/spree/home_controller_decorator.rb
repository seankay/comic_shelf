module Spree
  HomeController.class_eval do

    def index
      if current_store.subscription.trial? && current_user.try(:admin?) && request.path.eql?(spree_path)
        flash.now[:notice]= render_to_string(partial: 'shared/trial_flash').html_safe 
      end
      @searcher = Spree::Config.searcher_class.new(params)
      @searcher.current_user = try_spree_current_user
      @searcher.current_currency = current_currency
      @products = @searcher.retrieve_products
    end
  end
end

class StoresController < ApplicationController

  def show
    if(@store = current_store).nil?
      url = root_url(:host => request.domain)
      flash[:notice] = "Unable to find store by the name of #{request.subdomain}"
    else
      url = spree_url(:subdomain => @store.subdomain)
    end
    redirect_to url 
  end
end

class StoresController < ApplicationController

  def index
  end
  
  def show
    if(@store = current_store).nil?
      url = root_url(:host => request.domain)
      flash[:notice] = "Unable to find store by the name of #{request.subdomain}"
    else
      url = spree_url(:subdomain => @store.subdomain)
    end
    redirect_to url 
  end

  def new
    @store = Store.new 
  end

  def create
    DatabaseUtility.switch #Back to Public Schema
    @store = Store.new params[:store]
    if @store.save
      redirect_to signup_url(:subdomain => @store.subdomain)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end

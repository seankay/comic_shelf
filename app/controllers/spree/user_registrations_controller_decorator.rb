Spree::UserRegistrationsController.class_eval do
  
  def create_with_store
    @store = Store.new(name: params[:store_name])
    DatabaseUtility.switch 
    @user = build_resource(params[:user])
    if resource.valid?
      if @store.save
        DatabaseUtility.switch @store.subdomain
        create_devise_resource
      else
        @error_message = @store.error_reasons
      end
    else
      @error_message = resource.errors.full_messages.first
    end
    redirect_to main_app.root_url, alert: @error_message if @error_message
  end

  def create
    @store = current_store
    super
  end

  protected

  def after_sign_up_path_for(resource)
    main_app.spree_url(:subdomain => @store.subdomain)
  end
  
  def after_inactive_sign_up_path_for(resource)
    main_app.spree_url(:subdomain => @store.subdomain)
  end

  def after_sign_in_path_for(resource)
    main_app.spree_url(:subdomain => @store.subdomain)
  end

  private

  def create_devise_resource
    if resource.save
      if make_admin?
        setup_admin_resource
      end
      sign_in(:user, @user)
      session[:spree_user_signup] = true
      associate_user
      set_flash_message(:notice, :signed_up)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      clean_up_passwords(resource)
      @error_message = resource.errors.full_messages.first
    end
  end

  def make_admin?
    @store.spree_users.empty?
  end

  def setup_admin_resource
    resource.set_roles(["admin"])
    resource.store = @store
    create_subscription
  end

  def create_subscription
    subscription = Subscription.new(
      :email => resource.email,
      :plan_id => Plan.find_by_plan_identifier("low_plan").id,
    )
    subscription.store = @store
    subscription.save_without_payment
  end
end

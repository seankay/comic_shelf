class Users::RegistrationsController < Devise::RegistrationsController

  def create_with_store
    @store = Store.new(name: params[:store_name])
    build_resource

    DatabaseUtility.switch 
    if resource.valid?
      if @store.save
        DatabaseUtility.switch @store.subdomain
        create_devise_resource
      else
        error_message = @store.error_reasons
      end
    else
      error_message = resource.errors.full_messages.first
    end
    redirect_to root_path, alert: error_message  if error_message
  end

  def create
    @store = current_store
    build_resource
    create_devise_resource
  end

  protected

  def after_sign_up_path_for(resource)
    spree_url(:subdomain => @store.subdomain)
  end
  
  def after_inactive_sign_up_path_for(resource)
    spree_url(:subdomain => @store.subdomain)
  end

  private

  def create_devise_resource
    if resource.save
      if make_admin?
        setup_admin_resource
      end
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def make_admin?
    @store.users.empty?
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

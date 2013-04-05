class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if admin_flag = params[:user][:make_admin]
      params[:user].delete(:make_admin)
    end

    build_resource

    if resource.save
      if make_admin?(admin_flag)
        setup_admin_for(resource)
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

  protected

  def after_sign_up_path_for(resource)
    spree_url(:subdomain => request.subdomain)
  end
  
  def after_inactive_sign_up_path_for(resource)
    spree_url(:subdomain => request.subdomain)
  end

  private
  def make_admin? flag
    flag == "true" ? true : false
  end

  def setup_admin_for(resource)
    resource.set_roles(["admin"])
    resource.store = current_store
    create_subscription resource
  end

  def create_subscription resource
    subscription = Subscription.new(
      :email => resource.email,
      :plan_id => Plan.find_by_plan_identifier("low_plan").id,
    )
    subscription.store = current_store
    if subscription.save_without_payment
      current_store.subscription = subscription
    end
  end
end

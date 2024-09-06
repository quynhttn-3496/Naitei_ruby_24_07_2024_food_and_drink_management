class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource sign_up_params
    resource.save
    if resource.persisted?
      save_success
    else
      save_fail
    end
  end

  private
  def sign_up_params
    params.require(:user).permit User::PERMITTED_ATRIBUTES
  end

  def save_fail
    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
  end

  def save_success
    if resource.active_for_authentication?
      flash[:notice] = t "mess_sign_in_success"
      sign_up(resource_name, resource)
    else
      flash[:notice] = t "mess_confirm_mail"
      expire_data_after_sign_in!
    end
    respond_with resource, location: appropriate_path_for(resource)
  end

  def appropriate_path_for resource
    resource.admin? ? admin_path : root_path
  end
end

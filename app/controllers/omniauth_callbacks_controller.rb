class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:google_oauth2]

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success,
                          kind: "Google")
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url,
                  alert: @user.errors.full_messages.join("\n")
    end
  end

  private
  def after_sign_in_path_for resource
    appropriate_path_for resource
  end

  def appropriate_path_for resource
    resource.admin? ? admin_path : root_path
  end
end

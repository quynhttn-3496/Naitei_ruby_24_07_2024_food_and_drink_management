class ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      sign_in resource
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){redirect_to root_path}
    else
      respond_with_navigational(resource.errors,
                                status: :unprocessable_entity) do
        render :new
      end
    end
  end
end

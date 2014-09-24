class Devise::AuthenticationTokenController < DeviseController
  respond_to :json
  prepend_before_filter :require_no_authentication, :only => [:create ]
  skip_before_filter :verify_authenticity_token

  before_filter :ensure_params_exist


  def create
    resource = User.find_for_database_authentication(
      email: params[:user][:email]
    )
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      render json: {
        success: true,
        authentication_token: resource.authentication_token,
        email: resource.email
      }
      return
    end
    invalid_login_attempt
  end

  protected

    def ensure_params_exist
      return unless params[:user].blank?
      render json: {
        success: false,
        message: "missing user parameter"
      }, status: 422
    end

    def invalid_login_attempt
      warden.custom_failure!
      render json: {
        success: false,
        message: "Error with your login or password"
      }, status: 401
    end
end


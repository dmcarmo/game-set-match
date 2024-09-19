class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    
    resource.invitation_token = session.delete(:pending_invitation_token)
    
    super
  end
end

module TheRole
  module Controller
    extend ActiveSupport::Concern
    include ::Api::ApiRender

    def login_required
      send TheRole.config.login_required_method
    end

    def role_access_denied
      access_denied_method = TheRole.config.access_denied_method
      return send(access_denied_method) if access_denied_method && respond_to?(access_denied_method)

      the_role_default_access_denied_response
    end

    private

    def for_ownership_check obj
      @owner_check_object = obj
    end

    def role_required
      role_access_denied unless current_user.try(:has_role?, controller_path, action_name)
    end

    def owner_required
      role_access_denied unless current_user.try(:owner?, @owner_check_object)
    end

    def the_role_default_access_denied_response
      access_denied_msg = I18n.t(:access_denied, scope: :the_role)

      render json: { msg: access_denied_msg }, status: :forbidden
    end
  end
end

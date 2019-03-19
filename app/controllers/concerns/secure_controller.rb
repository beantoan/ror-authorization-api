module SecureController
  extend ActiveSupport::Concern

  included do
    include TheRole::Controller

    before_action :role_required

    before_action :set_current_user

    private

    def set_current_user
      User.current_user = current_user
    end
  end
end

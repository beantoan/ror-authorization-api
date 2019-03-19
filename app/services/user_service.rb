##
# Class UserService
##
class UserService < BaseService
  class << self
    def create(params)
      user = User.new(params)

      begin
        user.save!
        user
      rescue Exception => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('user.class_name'), reason: e.message, title: user.name)
      end
    end

    def update(user, params)
      begin
        user.update! params

        user
      rescue Exception => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('user.class_name'), reason: e.message, title: user.name)
      end
    end
  end
end
module Authorization
  extend ActiveSupport::Concern

  included do
    before_validation :set_creator

    belongs_to :creator, class_name: User.name, foreign_key: :creator_id
  end

  private

  def set_creator
    if new_record?
      if has_attribute?(:creator_id) && creator_id.blank? && User.current_user.present?
        self.creator_id = User.current_user.id
      end
    end
  end
end

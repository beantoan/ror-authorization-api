# == Schema Information
#
# Table name: roles
#
#  id          :bigint(8)        not null, primary key
#  description :text(65535)
#  name        :string(255)      not null
#  the_role    :text(65535)      not null
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Role < ActiveRecord::Base
  include TheRole::Api::Role

  # attr_accessor :is_admin

  before_validation :refine_values

  has_many :role_sections, class_name: RoleSection.name, foreign_key: :role_id
  has_many :sections, through: :role_sections

  validates :name, presence: true
  validates_uniqueness_of :name

  validates :title, presence: true
  validates_uniqueness_of :title

  UPDATABLE_ATTRIBUTES = %i[
    title name description
  ].freeze

  INDEX_ATTRIBUTES = %i[
    id title name description
  ].freeze

  private

  def refine_values
    if name.present?
      name.delete!(' ')
      self.name = name.mb_chars.downcase.to_s
    end

    if title.present?
      title.strip!
      title.squeeze!(' ')
      self.title = title.mb_chars.capitalize.to_s
    end
  end

end

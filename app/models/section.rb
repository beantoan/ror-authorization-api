# frozen_string_literal: true

# == Schema Information
#
# Table name: sections
#
#  id             :integer          unsigned, not null, primary key
#  action_key     :string(250)      not null
#  children_count :integer          default(0), unsigned, not null
#  depth          :integer          default(0), unsigned, not null
#  desc           :string(500)
#  is_display     :integer          default(0), unsigned, not null
#  lft            :integer          unsigned
#  name           :string(500)      not null
#  rgt            :integer          unsigned
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer          unsigned
#
# Indexes
#
#  index_sections_on_lft        (lft)
#  index_sections_on_parent_id  (parent_id)
#  index_sections_on_rgt        (rgt)
#

class Section < ApplicationRecord
  self.inheritance_column = :_type_disabled

  acts_as_nested_set counter_cache: :children_count

  before_validation :refine_values

  has_and_belongs_to_many :parent_sections,
                          class_name: Section.name,
                          join_table: :child_sections,
                          dependent: :delete_all,
                          association_foreign_key: :section_id,
                          foreign_key: :child_section_id

  has_and_belongs_to_many :child_sections,
                          class_name: Section.name,
                          dependent: :delete_all,
                          join_table: :child_sections,
                          association_foreign_key: :child_section_id,
                          foreign_key: :section_id

  has_many :role_sections, class_name: RoleSection.name, foreign_key: :section_id
  has_many :roles, through: :role_sections

  validates :action_key, presence: true
  validates_uniqueness_of :action_key, case_sensitive: false, scope: :parent_id

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: :parent_id

  UPDATABLE_ATTRIBUTES = %i[
    action_key name desc is_display parent_id
  ].freeze

  INDEX_ATTRIBUTES = %i[
    id action_key name depth children_count is_display parent_id
  ].freeze

  scope :is_display?, -> { where is_display: 1 }

  def title
    name.present? ? "#{name} - #{action_key}" : action_key
  end

  def title_with_parent
    if parent.nil?
      title
    else
      "#{name} - #{parent.action_key}##{action_key}"
    end
  end

  def action_key_with_parent
    if parent.nil?
      title
    else
      "#{parent.action_key}##{action_key}"
    end
  end

  def parent_name
    if parent.nil?
      name
    else
      "#{parent.action_key}##{name}"
    end
  end

  def self.roots_for_users
    roots.where(is_display: 1, type: :user)
  end

  private

  def refine_values
    if action_key.present?
      action_key.delete!(' ')
      action_key.downcase!
    end

    if name.present?
      name.strip!
      name.squeeze!(' ')
      self.name = name.mb_chars.capitalize.to_s
    end
  end
end

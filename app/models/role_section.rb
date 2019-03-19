# == Schema Information
#
# Table name: roles_sections
#
#  id           :integer          unsigned, not null, primary key
#  is_moderator :integer          default(0), unsigned, not null
#  role_id      :integer          unsigned, not null
#  section_id   :integer          unsigned, not null
#
# Indexes
#
#  index_roles_sections_on_role_id_and_section_id  (role_id,section_id) UNIQUE
#

class RoleSection < ApplicationRecord
  self.table_name = :roles_sections

  belongs_to :role
  belongs_to :section
end

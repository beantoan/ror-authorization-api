# == Schema Information
#
# Table name: child_sections
#
#  id               :integer          unsigned, not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  child_section_id :integer          unsigned, not null
#  section_id       :integer          unsigned, not null
#

class ChildSection < ApplicationRecord
  include Authorization

  belongs_to :parent_section, class_name: Section.name,
                              foreign_key: :section_id
  
  belongs_to :child_section, class_name: Section.name,
                             foreign_key: :child_section_id
end

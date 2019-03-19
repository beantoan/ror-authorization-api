##
# Class SectionService
##
class SectionService < BaseService
  class << self
    def create(params, child_section_ids)
      section = Section.new(params)

      begin
        section.child_section_ids = child_section_ids
        section.save!
        section
      rescue Exception => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('section.class_name'), reason: e.message, title: section.title)
      end
    end

    ##
    # Update section:
    # 1. Delete the related ChildSections if parent_id is blank
    # 2. Update the role if action_key is changed. Delete old sections in the role and insert new sections
    # 3. Update the role if child_section_ids is changed. Delete old sections in the role and insert new sections
    ##
    def update(section, params, child_section_ids)
      logger.debug params
      logger.debug child_section_ids

      begin
        Section.transaction do

          deleted_section_ids = section.child_section_ids.clone
          deleted_section_ids << section.id

          added_section_ids = child_section_ids.clone
          added_section_ids << section.id

          logger.debug deleted_section_ids
          logger.debug added_section_ids

          section.child_sections.clear

          section.child_section_ids = child_section_ids if params[:parent_id].present?

          Role.where(id: section.role_ids).each do |role|
            RoleSection.where(role_id: role.id, section_id: deleted_section_ids).delete_all

            role.section_ids = added_section_ids + role.section_ids if params[:parent_id].present?
          end

          section.update! params

          Role.in_batches.each_record do |role|
            RoleService.update_the_role role, role.section_ids, role.admin?
          end
        end

        section
      rescue Exception => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('section.class_name'), reason: e.message, title: section.title_with_parent)
      end
    end
  end
end
##
# Class RoleService
##
class RoleService < BaseService
  class << self

    ##
    # Create new role. If role is not an admin:
    # 1. Add sections to the_role which by the section_ids
    # 2. Add sections to the_role which by the ChildSection of section_ids
    # 3. Update roles_sections
    ##
    def create(params, section_ids, is_admin, configs)
      role = Role.new(params)

      begin
        Role.transaction do
          update_the_role role, section_ids, is_admin

          role.configs = is_admin ? [] : configs

          role.save!
        end

        role
      rescue ActiveRecord::ActiveRecordError => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('role.class_name'), reason: e.message, title: role.title)
      end
    end

    ##
    # Update role:
    ##
    def update(role, params, section_ids, is_admin, configs)
      begin

        Role.transaction do
          role.configs = is_admin ? [] : configs

          update_the_role role, section_ids, is_admin

          role.update! params
        end

        role
      rescue Exception => e
        logger.error e
        raise I18n.t('crud.save_error', class_name: I18n.t('role.class_name'), reason: e.message, title: role.title)
      end
    end

    ##
    # Update the_role for a role
    ##
    def update_the_role(role, section_ids, is_admin)
      role_hash = {}

      if is_admin.present? && is_admin
        role_hash = { system: { administrator: true } }

        role.sections.clear
      else
        sections = Section.select(:id, :action_key, :parent_id)
                          .where(id: section_ids)

        if sections.empty?
          role.sections.clear
        else

          cumulative_sections = sections

          role_hash = sections.map do |section|
            first_hash = if section.parent.nil?
                           {}
                         else
                           {
                             section.parent.action_key => {
                               section.action_key => true
                             }
                           }
                         end

            cumulative_sections += section.child_sections

            child_hashes = section.child_sections.map do |child|
              if child.parent.nil?
                {}
              else
                {
                  child.parent.action_key => {
                    child.action_key => true
                  }
                }
              end
            end

            if child_hashes.empty?
              first_hash
            else
              child_hashes.reduce(&:deep_merge).deep_merge(first_hash)
            end
          end

          role_hash = role_hash.reduce(&:deep_merge)

          role.sections = cumulative_sections.uniq
        end
      end

      role.the_role = '{}'
      role.update_role role_hash
    end

  end
end
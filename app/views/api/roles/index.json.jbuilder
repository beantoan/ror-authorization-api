json.total_pages @pagy.pages
json.total_elements @pagy.count
json.next_page @pagy.next
json.prev_page @pagy.prev
json.entries @roles do |role|
  json.id role.id
  json.name role.name
  json.title role.title
  json.description role.description
  json.is_admin role.admin?
  json.section_ids role.section_ids

  json.sections role.sections.is_display? do |section|
    json.extract! section, :id, :title_with_parent
  end
end
json.total_pages @pagy.pages
json.total_elements @pagy.count
json.next_page @pagy.next
json.prev_page @pagy.prev
json.entries @sections do |section|
  json.extract! section, :id, :action_key, :name, :depth, :children_count, :is_display, :parent_id
  json.child_section_ids section.child_section_ids

  json.children section.children do |child|
    json.extract! child, :id, :action_key, :name, :depth, :children_count, :is_display, :parent_id

    json.child_sections child.child_sections do |cs|
      json.extract! cs, :id, :title_with_parent
    end

    json.child_section_ids child.child_section_ids
  end
end
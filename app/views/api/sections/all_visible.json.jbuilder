json.array! @sections do |section|
  json.extract! section, :id, :action_key, :name

  json.children section.children.is_display? do |child|
    json.extract! child, :id, :title_with_parent
  end
end